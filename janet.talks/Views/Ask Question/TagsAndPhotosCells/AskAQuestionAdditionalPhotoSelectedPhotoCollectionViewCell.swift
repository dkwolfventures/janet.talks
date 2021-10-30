//
//  AskAQuestionAdditionalPhotoSelectedPhotoCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/29/21.
//

import UIKit

class AskAQuestionAdditionalPhotoSelectedPhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: - properties
    
    static let identifier = "AskAQuestionAdditionalPhotoSelectedPhotoCollectionViewCell"
    
    //create configureation for photo picker
    
    private let selectedImageImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectedImageImageView.fillSuperview()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedImageImageView.image = nil
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    private func configure(){
        backgroundColor = .systemGray4
        layer.masksToBounds = true
        layer.cornerRadius = 25
        clipsToBounds = true
        
        contentView.addSubview(selectedImageImageView)
    }
    
    public func configureImage(image: UIImage){
        self.selectedImageImageView.image = image
    }
    
}
