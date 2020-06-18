//
//  ListViewController.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 29.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import FirebaseFirestore

//MARK: - list of Active chats and new messaging Requests presented in this VC
class ListViewController: UIViewController {
	
	var activeChats = [Chat]()
	var waitingChats = [Chat]()
	private let currentUser: MWUser
	private var waitingChatsListener: ListenerRegistration?
	private var activeListener: ListenerRegistration?
	
	init(currentUser: MWUser) {
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
		title = currentUser.username
	}
	
	deinit {
		waitingChatsListener?.remove()
	}
	
	enum Section: Int, CaseIterable {
		case waitingChats, activeChats
		
		func description() -> String {
			switch self {
				case .waitingChats: return "Ожидают"
				case .activeChats: return "Чаты"
			}
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var dataSource: UICollectionViewDiffableDataSource<Section, Chat>?
	var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .buttonLight
		setupSearchBar()
		setupCollectionView()
		createDataSource()
		reloadData()
		createWaitingAndActiveChatsObservers()
	}
	
	private func createWaitingAndActiveChatsObservers() {
		waitingChatsListener = ListenerService.shared.waitingChatsObserve(
			chats: waitingChats,
			completion: { (result) in
				switch result {
					case .success(let chats):
						if !self.waitingChats.isEmpty, self.waitingChats.count <= chats.count {
							let confirmVC = ConfirmChatViewController(chat: chats.last!)
							confirmVC.delegate = self
							self.present(confirmVC, animated: true, completion: nil)
						}
						self.waitingChats = chats
						self.reloadData()
					case .failure(let error):
						self.showAlert(title: "Ошибка", message: "\(error.localizedDescription)")
				}
		})
		
		activeListener = ListenerService.shared.activeChatsObserve(
			chats: activeChats,
			completion: { (result) in
				switch result {
					case .success(let chats):
						self.activeChats = chats
						self.reloadData()
					case .failure(let error):
						print(error.localizedDescription)
				}
		})
	}
	
	private func reloadData() {
		var snapShot = NSDiffableDataSourceSnapshot<Section, Chat>()
		snapShot.appendSections([.waitingChats, .activeChats])
		snapShot.appendItems(waitingChats, toSection: .waitingChats)
		snapShot.appendItems(activeChats, toSection: .activeChats)
		dataSource?.apply(snapShot, animatingDifferences: true)
	}
	
	
	private func reloadData(with string: String?) {
		let filteredChats = activeChats.filter { (user) -> Bool in
			user.contains(filter: string)
		}
		
		var snapShot = NSDiffableDataSourceSnapshot<Section,Chat>()
		snapShot.appendSections([.waitingChats, .activeChats])
		snapShot.appendItems(waitingChats, toSection: .waitingChats)
		snapShot.appendItems(filteredChats, toSection: .activeChats)
		dataSource?.apply(snapShot, animatingDifferences: true)
	}
	
	private func setupSearchBar() {
		
		navigationController?.navigationBar.barTintColor = .buttonLight
		navigationController?.navigationBar.shadowImage = UIImage()
		let searchController = UISearchController(searchResultsController: nil)
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
	}

	private func setupCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createComposionalLayout())
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor  = .buttonLight
		view.addSubview(collectionView)
		
		collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
		collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
		collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
		collectionView.delegate = self
	}
	
}


//MARK: - wait navigation protocol
extension ListViewController: WaitNavigationProtocol {
	
	func removeChat(chat: Chat) {
		FireStoreService.shared.deleteWaitingChat(chat: chat) { (result) in
			switch result {
				case .success:
					self.showAlert(title: "Готово", message: "Чат с \(chat.friendUsername) удалён")
				case .failure(_):
					self.showAlert(title: "Ошибка", message: "Чат не удалён!")
			}
		}
	}
	
	func activateChat(chat: Chat) {
		print(#function)
		FireStoreService.shared.changeTopActive(chat: chat) { (result) in
			switch result {
				case .success:
					self.showAlert(title: "Готово", message: "Приятного общения с \(chat.friendUsername)")
				case .failure(let error):
					self.showAlert(title: "Ошибка", message: error.localizedDescription)
			}
		}
	}
	
	
}


//MARK: - collection view delegate
extension ListViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
		guard let section = Section(rawValue: indexPath.section) else { return }
		
		switch section {
			case .waitingChats:
				let confirmChatVC = ConfirmChatViewController(chat: chat)
				confirmChatVC.delegate = self
				self.present(confirmChatVC, animated: true, completion: nil)
			case .activeChats:
				print("Active chat \(indexPath.item)")
				let activeChatVC = ChatViewController(user: currentUser, chat: chat)
				self.navigationController?.pushViewController(activeChatVC, animated: true)
		}
	}
}

//MARK: - Data source
extension ListViewController {
	
	
	private func createDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section,Chat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, Chat) -> UICollectionViewCell? in
			
			guard let section = Section(rawValue: indexPath.section) else { fatalError("Не удалось создать секцию!") }
			
			switch section {
				
				case .activeChats:
					return self.configurate(collectionView: collectionView, cellType: ActiveChatCell.self, with: Chat, for: indexPath)
				
				case .waitingChats:
					return self.configurate(collectionView: collectionView, cellType: WaitingChatCell.self, with: Chat, for: indexPath)
			}
			
		})
		dataSource?.supplementaryViewProvider = {
			collectionView, kind, indexPath in
			
			guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Не могу создать SectionHeader!") }
			guard let section = Section(rawValue: indexPath.section) else { fatalError("Не могу создать Section!") }
			sectionHeader.configurate(text: section.description(), font: UIFont.appleSDGothicNeo18, textColor: UIColor.darkGray)
			return sectionHeader
		}
	}
	
	
}


//MARK: - Compositional layout
extension ListViewController {
	
	
	private func createActiveChats() -> NSCollectionLayoutSection {
		//создать item, затем создать group, затем создать section
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = 8
		section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
		
		let sectionHeader = createSectionHeader()
		section.boundarySupplementaryItems = [sectionHeader]
		
		return section
	}
	
	private func createWaitingChats() -> NSCollectionLayoutSection {
		//create items, after that create group, than create section
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(90), heightDimension: .absolute(90))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		let section = NSCollectionLayoutSection(group: group)
		
		section.interGroupSpacing = 20
		section.orthogonalScrollingBehavior = .continuous
		section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
		
		let sectionHeader = createSectionHeader()
		section.boundarySupplementaryItems = [sectionHeader]
		
		return section
	}
	
	private func createComposionalLayout() -> UICollectionViewLayout {
		
		//Layout = sections, inside of sections arranged groups, inside groupes arranged items
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			guard let section = Section(rawValue: sectionIndex) else { fatalError("Неизвестный индекс") }
			switch section {
				case .activeChats:
					return self.createActiveChats()
				case .waitingChats:
					return self.createWaitingChats()
			}
			
		}
		
		
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = 30
		layout.configuration = config
		
		return layout
	}
	
	private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
		
		let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
		let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: sectionHeaderSize,
			elementKind: UICollectionView.elementKindSectionHeader,
			alignment: .top)
		
		return sectionHeader
	}
	
}


//MARK: - Search Bar Delegate
extension ListViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		reloadData(with: searchText)
	}
	
}
