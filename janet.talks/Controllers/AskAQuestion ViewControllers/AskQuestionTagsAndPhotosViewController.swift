//
//  AskQuestionTagsAndPhotosViewController.swift
//  janet.talks
//
//  Created by Coding on 10/28/21.
//

import UIKit
import PhotosUI

class AskQuestionTagsAndPhotosViewController: UIViewController {
    
    //MARK: - properties
    private var configuration = PHPickerConfiguration()

    private var addedPhotosArray = [UIImage]()
    
    private lazy var spacing = view.spacing
    
    private var collectionView: UICollectionView?
    
    //MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tags & Photos"
        createCollectionView()
        configurePhotoPicker()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
        
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
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
                presentPicker()
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
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: self.view.spacing, bottom: 0, trailing: self.view.spacing)
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
        
        for result in results {
            count += 1
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self)
                { [weak self]  image, error in
                    if let image = image as? UIImage {
                        self?.addedPhotosArray.append(image)
                        
                        if count == (results.count) {
                            
                            DispatchQueue.main.async {
                                self?.view.showLoader(loadingWhat: "Loading Photos...")
                                picker.dismiss(animated: true)
                                self?.collectionView?.reloadData()
                                self?.view.dismissLoader()
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
}


