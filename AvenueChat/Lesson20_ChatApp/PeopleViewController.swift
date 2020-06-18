//
//  PeopleViewController.swift
//  Lesson20_ChatApp
//
//  Created by MacBook Air on 29.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//


import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

//MARK: - List of all new online users which you can write new first message
class PeopleViewController: UIViewController {
	
//	let users = Bundle.main.decode([FakeUser].self, from: "users.json")
	private var usersListener: ListenerRegistration?
	private let currentUser: MWUser
	var users = [MWUser]()
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Section, MWUser>!
	
	
	init(currentUser: MWUser) {
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
		title = currentUser.username
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		usersListener?.remove()
	}
	
	enum Section: Int, CaseIterable {
		case users
		
		func description(count: Int) -> String {
			return "Онлайн: \(count)"
		}
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
		setupSearchBar()
		setupCollectionView()
		createDataSource()
//		reloadData()
		usersListener = ListenerService.shared.usersObserve(users: users, completion: { (result) in
			switch result {
				
				case .success(let users):
					self.users = users
					self.reloadData()
				case .failure(let error):
					self.showAlert(title: "Ошибка", message: "Не удалось обновить данные")
					print(error)
			}
		})
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выйти", style: .done, target: self, action: #selector(signOut))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Профиль", style: .done, target: self, action: #selector(editProfile(_:)))
    }
	
	@objc private func editProfile(_ sender: UIBarButtonItem) {
		if sender == navigationItem.rightBarButtonItem {
			guard let currentUser =  Auth.auth().currentUser else { return }
			self.present(SetupProfileViewController(currentUser: currentUser), animated: true, completion: nil)
		}
	}
	
	@objc private func signOut() {
		
		let alert = UIAlertController(title: "Выход", message: "Вы уверены что хотите выйти?", preferredStyle: .alert)
		let yesAction = UIAlertAction(title: "Да", style: .destructive) { (_) in
			do {
				try Auth.auth().signOut()
				UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = AuthViewController()
				
			} catch {
				print("Не удалось выйти из профиля \(error.localizedDescription)")
			}
		}
		let noAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
		alert.addAction(yesAction)
		alert.addAction(noAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	
	
	private func reloadData() {
		var snapshot = NSDiffableDataSourceSnapshot<Section,MWUser>()
		snapshot.appendSections([.users])
		snapshot.appendItems(users, toSection: .users)
		dataSource.apply(snapshot)
	}
	
	private func reloadData(with string: String?) {
		let filteredUsers = users.filter { (user) -> Bool in
			user.contains(filter: string)
		}
		
		var snapshot = NSDiffableDataSourceSnapshot<Section,MWUser>()
		snapshot.appendSections([.users])
		snapshot.appendItems(filteredUsers, toSection: .users)
		dataSource.apply(snapshot, animatingDifferences: true)
	}
	
	private func setupCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createComposionalLayout())
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor  = .buttonLight
		view.addSubview(collectionView)
		
		collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
//		collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId) //Стоит вернуть если нужен header?
		collectionView.delegate = self
	}
	
	
	private func createDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section,MWUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
			guard let section = Section(rawValue: indexPath.section) else { fatalError("Не удалось создать user section") }
			
			switch section {
				case .users:
					return self.configurate(collectionView: collectionView, cellType: UserCell.self, with: user, for: indexPath)
			}
		})
		
		dataSource?.supplementaryViewProvider = {
			collectionView, kind, indexPath in
			
			guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Не могу создать SectionHeader!") }
			guard let section = Section(rawValue: indexPath.section) else { fatalError("Не могу создать Section!") }
			
			let itemsCount = self.dataSource?.snapshot().itemIdentifiers(inSection: .users).count
			sectionHeader.configurate(text: section.description(count: itemsCount!),
									  font: UIFont.appleSDGothicNeo18,
									  textColor: UIColor.darkGray)
			return sectionHeader
		}
	}
	
	
	private func createComposionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			guard let section = Section(rawValue: sectionIndex) else { fatalError("Не удалось создать секцию") }
			
			switch section {
				case .users:
					return self.createUsersSection()
			}
		})
		
		
		return layout
	}
	
	private func createUsersSection() -> NSCollectionLayoutSection {
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.55))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
		
		group.interItemSpacing = .fixed(15)
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 10, trailing: 20)
		
		return section
	}
	
	private func setupSearchBar() {
		navigationController?.navigationBar.barTintColor = .buttonLight
		navigationController?.navigationBar.shadowImage = UIImage()
		let searchController = UISearchController(searchResultsController: nil)
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = true
		searchController.hidesNavigationBarDuringPresentation = true
		searchController.obscuresBackgroundDuringPresentation = true
		searchController.searchBar.delegate = self
	}
	

}

//MARK: - UI collection view delegate
extension PeopleViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let user = self.dataSource.itemIdentifier(for: indexPath) else { return }
		let activeVC = ActiveChatViewController(user: user)
		self.present(activeVC, animated: true, completion: nil)
	}
}



//MARK: - Search Bar Delegate
extension PeopleViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		reloadData(with: searchText)
	}
	
}








//MARK: representation UI in Canvas
import SwiftUI

struct PeopleViewControllerProvider: PreviewProvider {
	
	static var previews: some View {
		ContainerView().edgesIgnoringSafeArea(.all)
	}
	
	
	struct ContainerView: UIViewControllerRepresentable {
		
		
		let VC = TabBarViewController()
		
		func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleViewControllerProvider.ContainerView>) -> TabBarViewController {
			return VC
		}
		
		func updateUIViewController(_ uiViewController: PeopleViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PeopleViewControllerProvider.ContainerView>) {
		}
		
	}
	
	
}
