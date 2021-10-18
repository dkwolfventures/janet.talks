//
//  HomeViewController.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    //MARK: - properties
    
    private var viewModels = [[PublicQuestionHomeFeedCellType]]()
    
    private var collectionView: UICollectionView?
    
    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    //MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchBar.placeholder = "Search..."
//        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
}

//MARK: - uiCollectionViewDelegate & dataSource

//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        0
//    }
//
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////
////    }
//
//}

//MARK: - setUpCollectionView

extension HomeViewController {
    
    func configureCollectionView() {
        let sectionHeight: CGFloat = 240 + view.width
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

                // Item
                let titleItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )
                
                let metaItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )
                
                let postItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )
                
                let actionItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(sectionHeight)
                    ),
                    subitems: [
                        titleItem,
                        metaItem,
                        postItem,
                        actionItem
                    ]
                )
                
                // Section
                let section = NSCollectionLayoutSection(group: group)

        //        if index == 0 {
        //            section.boundarySupplementaryItems = [
        //                NSCollectionLayoutBoundarySupplementaryItem(
        //                    layoutSize: NSCollectionLayoutSize(
        //                        widthDimension: .fractionalWidth(1),
        //                        heightDimension: .fractionalWidth(0.3)
        //                    ),
        //                    elementKind: UICollectionView.elementKindSectionHeader,
        //                    alignment: .top
        //                )
        //            ]
        //        }

                section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)

                return section
            })
        )

        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
//        collectionView.delegate = self
//        collectionView.dataSource = self
//
//        collectionView.register(
//            PosterCollectionViewCell.self,
//            forCellWithReuseIdentifier: PosterCollectionViewCell.identifer
//        )
//        collectionView.register(
//            PostCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostCollectionViewCell.identifer
//        )
//        collectionView.register(
//            PostActionsCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifer
//        )
//        collectionView.register(
//            PostLikesCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifer
//        )
//        collectionView.register(
//            PostCaptionCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifer
//        )
//        collectionView.register(
//            PostDateTimeCollectionViewCell.self,
//            forCellWithReuseIdentifier: PostDateTimeCollectionViewCell.identifer
//        )
//
//        collectionView.register(
//            StoryHeaderView.self,
//            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: StoryHeaderView.identifier
//        )

        self.collectionView = collectionView
    }
    
}

//MARK: - SearchResultsViewControllerDelegate

extension HomeViewController: SearchResultsViewControllerDelegate {
    
}
