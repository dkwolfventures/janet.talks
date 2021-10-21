//
//  HomeViewController.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import UIKit
import Firebase

class HomeViewController: UICollectionViewController {
    
    //MARK: - properties
    
    private var viewModels = [[PublicQuestionHomeFeedCellType]]()
    
    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    //MARK: - lifecycle
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
}

//MARK: - uiCollectionViewDelegate & dataSource

extension HomeViewController{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.section][indexPath.row]
        
        switch cellType {
        case .title(viewModel: let viewModel):
            <#code#>
        case .Meta(viewModel: let viewModel):
            <#code#>
        case .Post(viewModel: let viewModel):
            <#code#>
        case .Actions(viewModel: let viewModel):
            <#code#>
        }
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 15 - 15, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

}

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

        collectionView.backgroundColor = .systemBackground
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
