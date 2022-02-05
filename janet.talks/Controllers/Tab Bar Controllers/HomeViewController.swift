//
//  HomeViewController.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import UIKit
import Firebase
import SwiftUI

class HomeViewController: UIViewController {
    
    //MARK: - properties
    
    private var viewModels = [[PublicQuestionHomeFeedCellType]]()
    
    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    private var collectionView: UICollectionView?
    private var lastDoc: QueryDocumentSnapshot?
    
    //all posts
    private var allQs: [PublicQuestion] = []
    private var allQProfileUrls: [String:(String, Int)] = [:]
    
    ///where to paginate
    private var idxToWatchFor: IndexPath? = [4, 0]
    
    private let askQuestionButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "plus.circle")
        iv.tintColor = .label
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        
        configureCollectionView()
        
        fetchGlobalFeed()
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchBar.placeholder = "Search Qs..."
        
        //        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
        
        configureObserver()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    //MARK: - actions
    
    @objc func handleRefresh(){
        
        collectionView?.refreshControl?.beginRefreshing()
        
        let qGroup = DispatchGroup()
        qGroup.enter()
        
        DatabaseManager.shared.fetchGlobalFeed { [weak self] result in
            defer{
                qGroup.leave()
            }
            switch result {
            case .success(let qs):
                
                for q in qs.0 {
                    qGroup.enter()
                    StorageManager.shared.downloadProfileImageUrlForUsername(username: q.askerUsername) { [weak self] url in
                        defer {
                            qGroup.leave()
                        }
                        if let photoUrl = url.1.0 {
                            
                            self?.allQProfileUrls[url.0] = (photoUrl, url.1.1)
                            
                        }
                    }
                }
                
                self?.allQs = qs.0
                self?.lastDoc = qs.1
                self?.idxToWatchFor = [4,0]
            case .failure(let error):
                
                self?.showAlert(error)
            }
            
        }
        
        qGroup.notify(queue: .main){ [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.collectionView?.refreshControl?.endRefreshing()
                self?.collectionView?.reloadData()
            }
        }
        
    }
    
    @objc private func askQuestionTapped(){
        
        HapticsManager.shared.vibrateForSelection()
        
        let vc = AskAQuestionViewController()
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.prefersLargeTitles = true
        navVC.modalPresentationStyle = .fullScreen
        navVC.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        present(navVC, animated: true, completion: nil)
        
    }
    
    //MARK: - helpers
    
    private func configureNav(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(askQuestionTapped))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
    }
    
    private func fetchGlobalFeed(){
        
        let qGroup = DispatchGroup()
        qGroup.enter()
        
        DatabaseManager.shared.fetchGlobalFeed { [weak self] result in
            defer{
                qGroup.leave()
            }
            switch result {
            case .success(let qs):
                
                for q in qs.0 {
                    qGroup.enter()
                    StorageManager.shared.downloadProfileImageUrlForUsername(username: q.askerUsername) { [weak self] url in
                        defer {
                            qGroup.leave()
                        }
                        if let photoUrl = url.1.0 {
                            
                            self?.allQProfileUrls[url.0] = (photoUrl, url.1.1)
                            
                        }
                    }
                }
                
                self?.allQs = qs.0
                self?.lastDoc = qs.1
                
            case .failure(let error):
                
                self?.showAlert(error)
            }
            
        }
        
        qGroup.notify(queue: .main){ [weak self] in
                self?.view.dismissLoader()
                self?.collectionView?.reloadData()
        }
    }
    
    private func showAlert(_ error: Error){
        
        let alert = UIAlertController(title: "Uh Oh!", message: error.localizedDescription, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Okay!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func foundIndexNowPaginate(){
        
        if let idxToWatchFor = idxToWatchFor {
            
            let idxIs = idxToWatchFor[0]
            
            
            let qGroup = DispatchGroup()
            qGroup.enter()
            
            guard let lastDoc = lastDoc else {
                return
            }
            
            DatabaseManager.shared.addToGlobalFeed(lastDoc: lastDoc) { [weak self] result in
                
                self?.lastDoc = nil
                
                defer{
                    qGroup.leave()
                }
                
                switch result {
                case .success(let qs):
                    
                    for q in qs.0 {
                        qGroup.enter()
                        StorageManager.shared.downloadProfileImageUrlForUsername(username: q.askerUsername) { [weak self] url in
                            defer {
                                qGroup.leave()
                            }
                            if let photoUrl = url.1.0 {
                                
                                self?.allQProfileUrls[url.0] = (photoUrl, url.1.1)
                                
                            }
                        }
                    }
                    
                    if !self!.allQs.contains(qs.0[0]){
                        self?.allQs += qs.0
                    }

                    self?.idxToWatchFor = [idxIs + 5, 0]
                    self?.lastDoc = qs.1
                    
                case .failure(let error):
                    self?.showAlert(error)
                }
            }
            
            qGroup.notify(queue: .main){ [weak self] in
                self?.collectionView?.reloadData()
            }
        }
    }

}

//MARK: - private helpers
private extension HomeViewController{
    func configureObserver(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name.didAskQNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            self?.handleRefresh()
        }
    }
}

//MARK: - uiCollectionViewDelegate & dataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        allQs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section != (allQs.count - 1){
            return 5
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        let q = allQs[section]
        
        switch row {
        case 0:
            let viewModel = TitleCollectionViewCellViewModel(featuredImageUrl: q.featuredImageUrl, subject: q.title)
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TitleCollectionViewCell.identifier,
                for: indexPath) as? TitleCollectionViewCell else {
                    fatalError()
                }
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case 1:
            let viewModel = MetaCollectionViewCellViewModel(datePosted: q.askedDate, views: 0, answers: 0)
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MetaCollectionViewCell.identifier,
                for: indexPath) as? MetaCollectionViewCell else {
                    fatalError()
                }
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case 2:
            let viewModel = PostCollectionViewCellViewModel(snipet: q.question)
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: QuestionBodyCollectionViewCell.identifier,
                for: indexPath) as? QuestionBodyCollectionViewCell else {
                    fatalError()
                }
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
            
        case 3:
            let viewModel = ActionsCollectionViewCellViewModel(qID: q.questionID, profileImageUrl: allQProfileUrls[q.askerUsername]!.0, isLoved: q.lovers.contains(PersistenceManager.shared.username), username: q.askerUsername, qsAsked: allQProfileUrls[q.askerUsername]!.1, postLovers: q.lovers, comments: 0, shares: 0)
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterAndActionsCollectionViewCell.identifier,
                for: indexPath) as? PosterAndActionsCollectionViewCell else {
                    fatalError()
                }
            cell.configure(with: viewModel, index: indexPath.section)
            cell.delegate = self
            return cell
            
        case 4:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HeartSectionSeperatorCollectionViewCell.identifier,
                for: indexPath) as? HeartSectionSeperatorCollectionViewCell else {
                    fatalError()
                }
            return cell
        default:
            fatalError()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath[0] == allQs.count - 1 && idxToWatchFor != nil {
            foundIndexNowPaginate()
        }
    }
    
}

//MARK: - setUpCollectionView

extension HomeViewController {
    
    private func configureBodySectionHeight(section: Int, spacing: CGFloat) -> (NSCollectionLayoutItem, CGFloat) {
        
        if section >= allQs.count {
            
            let postItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(0)
                )
            )
            
            return (postItem, 0)
        }
        
        let questionBody = allQs[section].question
        
        let bodyHeight = questionBody.height(withConstrainedWidth: self.view.width - (spacing*3.8), font: .systemFont(ofSize: 18))
        
        var finalHeight: CGFloat {
            
            switch bodyHeight {
            case ...150:
                return bodyHeight + 45
                
            case ...(view.width - (spacing * 2)):
                return bodyHeight
                
            case (view.width - (spacing * 2))...:
                return view.width - (spacing * 2)
                    
            default:
                fatalError()
            }
        }
        
        let postItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(finalHeight)
            )
        )
        
        return (postItem, finalHeight)
    }
    
    func configureCollectionView() {
        
        view.showLoader(loadingWhat: "Loading Feed...")
        
        let sectionHeight: CGFloat = 260
        let spacing = view.spacing
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { [weak self] section, _ -> NSCollectionLayoutSection? in
                
                
                
                // Item
                let titleItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(100)
                    )
                )
                
                let metaItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(30)
                    )
                )
                
                let postItem = self?.configureBodySectionHeight(section: section, spacing: spacing)
                
                postItem?.0.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                
                let actionItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(110)
                    )
                )
                
                let heartItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(20)
                    )
                )
                
                heartItem.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(sectionHeight + postItem!.1)
                    ),
                    subitems: [
                        titleItem,
                        metaItem,
                        postItem!.0,
                        actionItem,
                        heartItem
                    ]
                )
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: spacing, bottom: 10, trailing: spacing)
                
                return section
            })
        )
        
        let refresher = UIRefreshControl()
        collectionView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        view.addSubview(collectionView)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            TitleCollectionViewCell.self,
            forCellWithReuseIdentifier: TitleCollectionViewCell.identifier
        )
        collectionView.register(
            MetaCollectionViewCell.self,
            forCellWithReuseIdentifier: MetaCollectionViewCell.identifier
        )
        collectionView.register(
            QuestionBodyCollectionViewCell.self,
            forCellWithReuseIdentifier: QuestionBodyCollectionViewCell.identifier
        )
        collectionView.register(
            PosterAndActionsCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterAndActionsCollectionViewCell.identifier
        )
        collectionView.register(
            HeartSectionSeperatorCollectionViewCell.self,
            forCellWithReuseIdentifier: HeartSectionSeperatorCollectionViewCell.identifier
        )
        self.collectionView = collectionView
    }
    
}

//MARK: - PosterAndActionsCollectionViewCellDelegate

extension HomeViewController: PosterAndActionsCollectionViewCellDelegate {
    func loveButtonTapped(_ cell: PosterAndActionsCollectionViewCell, isLoved: Bool, index: Int) {
        HapticsManager.shared.vibrateForSelection()
        let post = allQs[index]
        let username = PersistenceManager.shared.username
        
        DatabaseManager.shared.updateLikeState(state: isLoved ? .love : .unlove, qID: post.questionID, username: username) { success in
            guard success else {
                return
            }
            
            
        }
    }
}

//MARK: - SearchResultsViewControllerDelegatw

extension HomeViewController: SearchResultsViewControllerDelegate {
    
}
