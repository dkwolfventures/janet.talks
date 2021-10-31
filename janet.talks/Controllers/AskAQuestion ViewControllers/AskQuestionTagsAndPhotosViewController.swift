//
//  AskQuestionTagsAndPhotosViewController.swift
//  janet.talks
//
//  Created by Coding on 10/28/21.
//

import UIKit
import PhotosUI

protocol AskQuestionTagsAndPhotosViewControllerDelegate: AnyObject {
    func addTagsAndOrPhotos(tags: [String]?, photos: [UIImage]?)
}

class AskQuestionTagsAndPhotosViewController: UIViewController {
    
    //MARK: - properties
    
    weak var delegate: AskQuestionTagsAndPhotosViewControllerDelegate?
    
    private var question: PublicQuestionToAdd
    
    private var configuration = PHPickerConfiguration()

    private var addedPhotosArray = [UIImage]()
    private var tags = String()
    
    private lazy var spacing = view.spacing
    
    private var collectionView: UICollectionView?
    
    //MARK: - lifecycle
    
    init(question: PublicQuestionToAdd){
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        title = "Tags & Photos"
        configureElements()
        createCollectionView()
        configurePhotoPicker()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
        
    }
    
    //MARK: - actions
    
    @objc func addTagsAndOrPhotos(){
        
        let legitTags = self.getTags(tags: tags)
        let photos = addedPhotosArray
        
        navigationController?.popViewController(animated: true)
        delegate?.addTagsAndOrPhotos(tags: legitTags, photos: photos)
    }
    
    //MARK: - helpers
    
    private func getTags(tags: String) -> [String]? {
        
        var results = [String]()
        
        if tags.count < 2 {
            return nil
        }
        
        let tagArr = tags.split(separator: "#")
        
        tagArr.forEach { tag in
            results.append("\(tag)")
        }
        
        return results
    }
    
    private func configureElements(){
        
        if let legitTags = question.tags {
            self.tags = "#" + legitTags.joined(separator: " #")
        }
        
        if let photos = question.questionImages {
            self.addedPhotosArray = photos
        }
    }
    
    private func configureNavigation(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(addTagsAndOrPhotos))
    }
    
    private func presentDeletionAlert(index: Int){
        
        HapticsManager.shared.vibrate(for: .warning)
        
        let alert = UIAlertController(title: "Are you sure...", message: "you would like to remove this photo?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            
            self?.addedPhotosArray.remove(at: index)
            HapticsManager.shared.vibrateForSelection()
            self?.collectionView?.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
    }
    
    private func presentPicker(){
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    private func configurePhotoPicker(){
        configuration.filter = .images
        configuration.selectionLimit = 0
    }
    
    private func addPhoto(){
        addedPhotosArray.append(UIImage())
        collectionView?.reloadData()
    }
    
    private func showTags(tags: [String]?) -> String? {
        
        if let tags = tags {
            return "#" + tags.joined(separator: " #")
        } else {
            return nil
        }
        
    }
}

//MARK: - SectionHeading

extension AskQuestionTagsAndPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return (1 + addedPhotosArray.count)
        default:
            fatalError()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        
        switch section {
        case 0:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AskAQuestionTagsCollectionViewCell.identifier, for: indexPath) as! AskAQuestionTagsCollectionViewCell
            cell.delegate = self
            
            cell.configure(with: question.tags)
            return cell
            
        case 1:
            
            if indexPath.row == addedPhotosArray.count {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AskAQuestionAdditionalPhotoCollectionViewCell.identifier, for: indexPath) as! AskAQuestionAdditionalPhotoCollectionViewCell
                return cell
                
            } else {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AskAQuestionAdditionalPhotoSelectedPhotoCollectionViewCell.identifier, for: indexPath) as! AskAQuestionAdditionalPhotoSelectedPhotoCollectionViewCell
                cell.configureImage(image: addedPhotosArray[indexPath.row])
                return cell
                
            }
            
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 0:
            break
            
        case 1:
            
            if indexPath.row == addedPhotosArray.count {
                HapticsManager.shared.vibrateForSelection()
                presentPicker()
            } else {
                presentDeletionAlert(index: indexPath.row)
            }
            
        default:
            fatalError()
        }
    }
}

//MARK: - createSectionLayout

extension AskQuestionTagsAndPhotosViewController {
    
    private func configureCollectionView(){
        
    }
    
    func createCollectionView(){
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
                
                switch section {
                case 0:
                    
                    let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalHeight(1))
                    )
                    
                    let group = NSCollectionLayoutGroup.vertical(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(0.75)),
                        subitem: item,
                        count: 1)
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: self.view.spacing, leading: self.view.spacing, bottom: 0, trailing: self.view.spacing)
                    return section
                    
                case 1:
                    
                    let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(0.5),
                            heightDimension: .fractionalHeight(1))
                    )
                    
                    item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(0.5)),
                        subitem: item,
                        count: 3)
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: self.view.spacing, leading: self.view.spacing, bottom: 5, trailing: self.view.spacing)
                    return section
                    
                default:
                    fatalError()
                }
                
            }))
        
        view.addSubview(collectionView)
        collectionView.register(AskAQuestionTagsCollectionViewCell.self, forCellWithReuseIdentifier: AskAQuestionTagsCollectionViewCell.identifier)
        
        collectionView.register(AskAQuestionAdditionalPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AskAQuestionAdditionalPhotoCollectionViewCell.identifier)

        collectionView.register(AskAQuestionAdditionalPhotoSelectedPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AskAQuestionAdditionalPhotoSelectedPhotoCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .secondarySystemBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.collectionView = collectionView
        
    }
    
}

extension AskQuestionTagsAndPhotosViewController: PHPickerViewControllerDelegate {
    
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        var count: Int = 0
        
        DispatchQueue.main.async { [weak self] in
            
            picker.dismiss(animated: true)
            
            if !results.isEmpty {
                HapticsManager.shared.vibrateForSelection()
                
                self?.view.showLoader(loadingWhat: "Loading Photos...")
            }
        }
        
        for result in results {
            count += 1
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self)
                { [weak self]  image, error in
                    if let image = image as? UIImage {
                        self?.addedPhotosArray.append(image)
                        
                        if count == results.count {
                            DispatchQueue.main.async {
                                self?.collectionView?.reloadData()
                                self?.view.dismissLoader()
                                HapticsManager.shared.vibrateForSelection()
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - AskAQuestionTagsCollectionViewCellDelegate

extension AskQuestionTagsAndPhotosViewController: AskAQuestionTagsCollectionViewCellDelegate {
    func tagsChanged(tags: String) {
        self.tags = tags
    }
}
