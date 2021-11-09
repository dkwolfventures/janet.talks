//
//  PreviewQuestionCollectionViewController.swift
//  janet.talks
//
//  Created by Coding on 10/31/21.
//

import UIKit

class PreviewQuestionCollectionViewController: UIViewController {
    
    //MARK: - properties
    
    private var collectionView: UICollectionView?
    
    private let question: PublicQuestionToAdd
    private var viewModels = [[PreviewQuestionCellType]]()
    
    //MARK: - lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNav()
    }
    
    init(question: PublicQuestionToAdd){
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureQuestion()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    private func configureNav(){
        
        title = "Preview Q"
        
    }
    
    private func configureQuestion(){
        if let featuredImage = question.featuredImage, let title = question.title, let questionBody = question.question, let background = question.situationOrBackground, let tags = question.tags, let photos = question.questionImages {
            let question = PublicQuestionToAdd(
                featuredImage: featuredImage,
                title: title,
                question: questionBody,
                situationOrBackground: background,
                tags: tags,
                questionImages: photos)
            
            self.createViewModels(question: question) { [weak self] success in
                if success {
                    self?.collectionView?.reloadData()
                }
            }
        }
        
    }
    
    private func createViewModels(question: PublicQuestionToAdd, completion: @escaping(Bool) -> Void){
        
        let questionData: [PreviewQuestionCellType] = [
            .Title(viewModel: PreviewQuestionTitleViewModel(
                featuredImageUrl: question.featuredImage!,
                subject: question.title!)),
            .Tags(viewModel: PreviewQuestionTagsViewModel(
                tags: question.tags!)),
            .Meta(viewModel: PreviewQuestionMetaViewModel(
                datePosted: "Today at \(Date().shortTime)",
                views: 0,
                answers: 0)),
            .Question(viewModel: PreviewQuestionQuestionBodyViewModel(
                question: question.question!)),
            .Background(viewModel: PreviewQuestionBackgroundViewModel(
                background: question.situationOrBackground!)),
            .Photos(viewModel: PreviewQuestionPhotosViewModel(
                photos: question.questionImages!))
        ]
        
        self.viewModels.append(questionData)
        completion(true)
    }
    
}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension PreviewQuestionCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModels[section].count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = viewModels[indexPath.section][indexPath.row]
        
        switch cellType{
            
        case .Title(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewQuestionTitleCollectionViewCell.identifier, for: indexPath) as! PreviewQuestionTitleCollectionViewCell
            cell.configure(with: viewModel)
            return cell
            
        case .Tags(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewQuestionTagsCollectionViewCell.identifier, for: indexPath) as! PreviewQuestionTagsCollectionViewCell
            cell.configureButtons(viewModel: viewModel)
            return cell
            
        case .Meta(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewQuestionMetaCollectionViewCell.identifier, for: indexPath) as! PreviewQuestionMetaCollectionViewCell
            cell.configure(with: viewModel)
            return cell
            
        case .Question(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewQuestionQuesitonBodyCollectionViewCell.identifier, for: indexPath) as! PreviewQuestionQuesitonBodyCollectionViewCell
            cell.configure(with: viewModel)
            return cell
            
        case .Background(let viewModel):
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewQuesitonBackgroundCollectionViewCell.identifier, for: indexPath) as! PreviewQuesitonBackgroundCollectionViewCell
            if question.situationOrBackground != "" {
                cell.configure(with: viewModel)
            }
            return cell
            
        case .Photos(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewQuestionPhotosCollectionViewCell.identifier, for: indexPath) as! PreviewQuestionPhotosCollectionViewCell
            cell.configureButtons(viewModel: viewModel)
            return cell
            
        }
        
    }
    
}

//MARK: - configureCollectionView

extension PreviewQuestionCollectionViewController {

    
    private func configureCollectionView(){
        
        let spacing = view.width/20
        let width = view.width
        
        let questionHeight = (question.question?.height(withConstrainedWidth: width - (spacing * 4), font: .systemFont(ofSize: 18)))! + 40
        
        var backgroundHeight: CGFloat{
            return question.situationOrBackground == "" ? 0 : (question.situationOrBackground?.height(withConstrainedWidth: width - (spacing * 4), font: .systemFont(ofSize: 18)))! + 40
        }
        
        var photoWidth: CGFloat{
            return question.questionImages == [] ? 0 : ((width) / 2) + 10
        }
        
        var tagHeight: CGFloat {
            return question.tags == [] ? 0 : 50
        }
        
        let sectionDynamicNumbers = tagHeight + questionHeight + backgroundHeight + photoWidth

        let sectionHeight: CGFloat = 130 + sectionDynamicNumbers
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

                // Item
                let titleItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(100)
                    )
                )
                
                let tagItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(tagHeight)
                    )
                )
                
                tagItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: -spacing, bottom: 0, trailing: -spacing)
                
                let metaItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(30)
                    )
                )
                
                metaItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
                
                let postItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(questionHeight)
                    )
                )
                
                postItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                
                let backgroundItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(backgroundHeight)
                    )
                )
                
                backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                
                let photoItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(photoWidth)
                    )
                )
                
                photoItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -spacing, bottom: 10, trailing: -spacing)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(sectionHeight)
                    ),
                    subitems: [
                        titleItem,
                        tagItem,
                        metaItem,
                        postItem,
                        backgroundItem,
                        photoItem
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
            PreviewQuestionTitleCollectionViewCell.self,
            forCellWithReuseIdentifier: PreviewQuestionTitleCollectionViewCell.identifier
        )
        collectionView.register(
            PreviewQuestionTagsCollectionViewCell.self,
            forCellWithReuseIdentifier: PreviewQuestionTagsCollectionViewCell.identifier
        )
        collectionView.register(
            PreviewQuestionMetaCollectionViewCell.self,
            forCellWithReuseIdentifier: PreviewQuestionMetaCollectionViewCell.identifier
        )
        collectionView.register(
            PreviewQuestionQuesitonBodyCollectionViewCell.self,
            forCellWithReuseIdentifier: PreviewQuestionQuesitonBodyCollectionViewCell.identifier
        )
        collectionView.register(
            PreviewQuesitonBackgroundCollectionViewCell.self,
            forCellWithReuseIdentifier: PreviewQuesitonBackgroundCollectionViewCell.identifier
        )
        collectionView.register(
            PreviewQuestionPhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: PreviewQuestionPhotosCollectionViewCell.identifier
        )
        
        self.collectionView = collectionView
    }
}
