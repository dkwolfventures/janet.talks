//
//  HomeViewController.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - properties
    
    private var viewModels = [[PublicQuestionHomeFeedCellType]]()
    
    private var collectionView: UICollectionView?
    
    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
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
    
    @objc private func askQuestionTapped(){
        
        let topItem = IndexPath(row: 0, section: 0)
        
        self.collectionView?.scrollToItem(at: topItem, at: .top, animated: true)
        
        let vc = AskAQuestionViewController()
        addChild(vc)
        vc.delegate = self
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame: CGRect = CGRect(x: 0, y: 0 - view.height, width: view.width, height: view.height)
        vc.view.frame = frame
        collectionView?.isScrollEnabled = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            vc.view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            self?.askQuestionButton.isUserInteractionEnabled = false
            self?.askQuestionButton.alpha = 0.5
            
        }

    }
    
    //MARK: - helpers
    
    
    private func configureNav(){
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(askQuestionButton)
        askQuestionButton.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        askQuestionButton.clipsToBounds = true
        askQuestionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            askQuestionButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                                     constant: -Const.ImageRightMargin),
            askQuestionButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                                      constant: -Const.ImageBottomMarginForLargeState),
            askQuestionButton.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            askQuestionButton.widthAnchor.constraint(equalTo: askQuestionButton.heightAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(askQuestionTapped))
        tap.numberOfTapsRequired = 1
        askQuestionButton.addGestureRecognizer(tap)
        
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0

        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        askQuestionButton.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
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

//MARK: - AskAQuestionDelegate

extension HomeViewController: AskAQuestionDelegate {
    
    func closeAskAQuestion(_ vc: AskAQuestionViewController) {
        let frame: CGRect = vc.view.frame
        vc.view.frame = frame
        UIView.animate(withDuration: 0.5) {
            vc.view.frame = CGRect(x: 0, y: 0 + self.view.height, width: self.view.width, height: self.view.height)
                self.askQuestionButton.alpha = 1
        } completion: { [weak self] done in
            if done {
                vc.view.removeFromSuperview()
                vc.removeFromParent()
                
                self?.askQuestionButton.isUserInteractionEnabled = true
                self?.collectionView?.isScrollEnabled = true

            }
        }
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
