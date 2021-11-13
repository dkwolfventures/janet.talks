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
    
    //all posts
    private var allQs: [PublicQuestion] = []
    
    /// Notification observer
    private var observer: NSObjectProtocol?

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
        
        view.showLoader(loadingWhat: "Loading Feed...")
        configureCollectionView()
        fetchGlobalFeed()
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchBar.placeholder = "Search Qs..."
        
//        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
    
        observer = NotificationCenter.default.addObserver(forName: .didAskQNotification, object: PublicQuestionToAdd.self, queue: .main){ [weak self] _ in
            self?.viewModels.removeAll()
            self?.fetchGlobalFeed()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.frame
    }
    
    //MARK: - actions
    
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
        
        let post1 = PublicQuestion(questionID: "111", title: "What Is The Secret To A Perfect Relationship?", featuredImageUrl: "none", tags: ["janet", "relationshipadvice", "follow4follow"], askedDate: Date().mediumDateTime.lowercased(), question: "Mustache cliche squid roof party twee cornhole. Vinyl offal selvage sustainable direct trade, post-ironic cornhole affogato vape echo park authentic locavore whatever squid. Gastropub church-key blue bottle taiyaki mlkshk, kitsch direct trade everyday carry 90's selvage cold-pressed helvetica. Yr blue bottle chicharrones church-key. Cronut raw denim copper mug you probably haven't heard of them salvia kale chips gluten-free crucifix jean shorts migas affogato woke church-key. Viral portland authentic stumptown +1 vegan ennui put a bird on it. Hexagon sriracha readymade hot chicken gastropub mlkshk, tousled flannel four loko lo-fi slow-carb ugh godard. Keffiyeh small batch gochujang, tacos 90's hell of kale chips. Fingerstache drinking vinegar af, chicharrones ennui cornhole neutra art party occupy bespoke poutine try-hard salvia. Occupy taxidermy synth pitchfork, bushwick banjo beard glossier coloring book. Tousled man bun edison bulb thundercats, art party stumptown affogato ugh street art kombucha 3 wolf moon.", background: "Mustache cliche squid roof party twee cornhole. Vinyl offal selvage sustainable direct trade, post-ironic cornhole affogato vape echo park authentic locavore whatever squid. Gastropub church-key blue bottle taiyaki mlkshk, kitsch direct trade everyday carry 90's selvage cold-pressed helvetica. Yr blue bottle chicharrones church-key. Cronut raw denim copper mug you probably haven't heard of them salvia kale chips gluten-free crucifix jean shorts migas affogato woke church-key. Viral portland authentic stumptown +1 vegan ennui put a bird on it. Hexagon sriracha readymade hot chicken gastropub mlkshk, tousled flannel four loko lo-fi slow-carb ugh godard. Keffiyeh small batch gochujang, tacos 90's hell of kale chips. Fingerstache drinking vinegar af, chicharrones ennui cornhole neutra art party occupy bespoke poutine try-hard salvia. Occupy taxidermy synth pitchfork, bushwick banjo beard glossier coloring book. Tousled man bun edison bulb thundercats, art party stumptown affogato ugh street art kombucha 3 wolf moon.", numOfPhotos: 0, questionPhotoURLs: nil, lovers: [], askerUsername: "@kenton")
        
        let post2 = PublicQuestion(questionID: "111", title: "What Is The Secret To A Perfect Relationship?", featuredImageUrl: "none", tags: ["janet", "relationshipadvice", "follow4follow"], askedDate: Date().mediumDateTime.lowercased(), question: "Mustache cliche squid roof party twee cornhole. Vinyl offal selvage sustainable direct trade, post-ironic cornhole affogato vape echo park authentic locavore whatever squid. Gastropub church-key blue bottle taiyaki mlkshk, kitsch direct trade everyday carry 90's selvage cold-pressed helvetica.", background: "Mustache cliche squid roof party twee cornhole. Vinyl offal selvage sustainable direct trade, post-ironic cornhole affogato vape echo park authentic locavore whatever squid. Gastropub church-key blue bottle taiyaki mlkshk, kitsch direct trade everyday carry 90's selvage cold-pressed helvetica. Yr blue bottle chicharrones church-key. Cronut raw denim copper mug you probably haven't heard of them salvia kale chips gluten-free crucifix jean shorts migas affogato woke church-key. Viral portland authentic stumptown +1 vegan ennui put a bird on it. Hexagon sriracha readymade hot chicken gastropub mlkshk, tousled flannel four loko lo-fi slow-carb ugh godard. Keffiyeh small batch gochujang, tacos 90's hell of kale chips. Fingerstache drinking vinegar af, chicharrones ennui cornhole neutra art party occupy bespoke poutine try-hard salvia. Occupy taxidermy synth pitchfork, bushwick banjo beard glossier coloring book. Tousled man bun edison bulb thundercats, art party stumptown affogato ugh street art kombucha 3 wolf moon.", numOfPhotos: 0, questionPhotoURLs: nil, lovers: [], askerUsername: "@kenton")
        
        let post3 = PublicQuestion(questionID: "111", title: "What Is The Secret To A Perfect Relationship?", featuredImageUrl: "none", tags: ["janet", "relationshipadvice", "follow4follow"], askedDate: Date().mediumDateTime.lowercased(), question: "Mustache cliche squid roof party twee cornhole. Vinyl offal selvage sustainable direct trade, post-ironic cornhole affogato vape echo park authentic locavore whatever squid. Gastropub church-key blue bottle taiyaki mlkshk, kitsch direct trade everyday carry 90's selvage cold-pressed helvetica. Yr blue bottle chicharrones church-key.", background: "Mustache cliche squid roof party twee cornhole. Vinyl offal selvage sustainable direct trade, post-ironic cornhole affogato vape echo park authentic locavore whatever squid. Gastropub church-key blue bottle taiyaki mlkshk, kitsch direct trade everyday carry 90's selvage cold-pressed helvetica. Yr blue bottle chicharrones church-key. Cronut raw denim copper mug you probably haven't heard of them salvia kale chips gluten-free crucifix jean shorts migas affogato woke church-key. Viral portland authentic stumptown +1 vegan ennui put a bird on it. Hexagon sriracha readymade hot chicken gastropub mlkshk, tousled flannel four loko lo-fi slow-carb ugh godard. Keffiyeh small batch gochujang, tacos 90's hell of kale chips. Fingerstache drinking vinegar af, chicharrones ennui cornhole neutra art party occupy bespoke poutine try-hard salvia. Occupy taxidermy synth pitchfork, bushwick banjo beard glossier coloring book. Tousled man bun edison bulb thundercats, art party stumptown affogato ugh street art kombucha 3 wolf moon.", numOfPhotos: 0, questionPhotoURLs: nil, lovers: [], askerUsername: "@kenton")
        
        let post4 = PublicQuestion(questionID: "111", title: "What Is The Secret To A Perfect Relationship?", featuredImageUrl: "none", tags: ["janet", "relationshipadvice", "follow4follow"], askedDate: Date().mediumDateTime.lowercased(), question: "Mustache cliche squid roof party twee cornhole. Vinyl offal selvage sustainable direct trade, post-ironic cornhole affogato vape echo park authentic locavore whatever squid.", background: "Mustache cliche squid roof party twee cornhole. Vinyl offal selvage sustainable direct trade, post-ironic cornhole affogato vape echo park authentic locavore whatever squid. Gastropub church-key blue bottle taiyaki mlkshk, kitsch direct trade everyday carry 90's selvage cold-pressed helvetica. Yr blue bottle chicharrones church-key. Cronut raw denim copper mug you probably haven't heard of them salvia kale chips gluten-free crucifix jean shorts migas affogato woke church-key. Viral portland authentic stumptown +1 vegan ennui put a bird on it. Hexagon sriracha readymade hot chicken gastropub mlkshk, tousled flannel four loko lo-fi slow-carb ugh godard. Keffiyeh small batch gochujang, tacos 90's hell of kale chips. Fingerstache drinking vinegar af, chicharrones ennui cornhole neutra art party occupy bespoke poutine try-hard salvia. Occupy taxidermy synth pitchfork, bushwick banjo beard glossier coloring book. Tousled man bun edison bulb thundercats, art party stumptown affogato ugh street art kombucha 3 wolf moon.", numOfPhotos: 0, questionPhotoURLs: nil, lovers: [], askerUsername: "@kenton")
        
        let posts = [post1, post2, post3, post4]
        
        self.allQs = posts
        
        posts.forEach { question in
            createViewModels(question: question, username: question.askerUsername) { [weak self] success in
                
                if success {
                    self?.view.dismissLoader()
                    self?.collectionView?.reloadData()
                }
                
            }
        }
        
    }
    
    private func createViewModels(question: PublicQuestion, username: String, completion: @escaping(Bool) -> Void){
        
        
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        StorageManager.shared.profilePictureURL(for: username) { [weak self] profileImageUrl in
            
            guard let profileImageUrl = URL(string: "gs://janet-mvp.appspot.com/users/66BE313D-ABC8-48B5-B7C1-09F47B7CE0C6/profile_pictures"), let featuredImageUrl = URL(string: "www.google.com") else {
                return
            }
            
            let isLoved = question.lovers.contains(currentUsername)
            
            let postData: [PublicQuestionHomeFeedCellType] = [
                
                    .Title(viewModel: TitleCollectionViewCellViewModel(
                        featuredImageUrl: featuredImageUrl,
                        subject: question.title)),
                
                    .Meta(viewModel: MetaCollectionViewCellViewModel(
                        datePosted: question.askedDate,
                        views: 1000,
                        answers: 500)),
                
                    .Post(viewModel: PostCollectionViewCellViewModel(
                        snipet: question.question)),
                
                    .Actions(viewModel: ActionsCollectionViewCellViewModel(
                        profileImageUrl: profileImageUrl,
                        isLoved: isLoved,
                        username: username,
                        qsAsked: 200,
                        postLovers: 300,
                        comments: 231,
                        shares: 100)),
                    
                    .Heart
            ]
            
            self?.viewModels.append(postData)
            completion(true)
        }
    }
    
}

//MARK: - uiCollectionViewDelegate & dataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.section][indexPath.row]
        
        switch cellType {
        case .Title(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TitleCollectionViewCell.identifier,
                for: indexPath) as? TitleCollectionViewCell else {
                    fatalError()
                }
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .Meta(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MetaCollectionViewCell.identifier,
                for: indexPath) as? MetaCollectionViewCell else {
                    fatalError()
                }
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .Post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: QuestionBodyCollectionViewCell.identifier,
                for: indexPath) as? QuestionBodyCollectionViewCell else {
                    fatalError()
                }
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
            
        case .Actions(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterAndActionsCollectionViewCell.identifier,
                for: indexPath) as? PosterAndActionsCollectionViewCell else {
                    fatalError()
                }
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
            
        case .Heart:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HeartSectionSeperatorCollectionViewCell.identifier,
                for: indexPath) as? HeartSectionSeperatorCollectionViewCell else {
                    fatalError()
                }
            return cell
        }
        
    }
    
}

//MARK: - setUpCollectionView

extension HomeViewController {
    
    private func configureBodySectionHeight(section: Int, spacing: CGFloat) -> (NSCollectionLayoutItem, CGFloat) {
        
        let questionBody = allQs[section].question
        
        let bodyHeight = questionBody.height(withConstrainedWidth: self.view.width - (spacing*3.8), font: .systemFont(ofSize: 18))
        
        var finalHeight: CGFloat {
            return bodyHeight > (view.width - (spacing * 2)) ? view.width - (spacing * 2) : bodyHeight
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
        let sectionHeight: CGFloat = 300
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
                        heightDimension: .absolute(25)
                    )
                )
                
                heartItem.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 0, bottom: 25, trailing: 0)
                
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

//MARK: - SearchResultsViewControllerDelegate

extension HomeViewController: SearchResultsViewControllerDelegate {
    
}
