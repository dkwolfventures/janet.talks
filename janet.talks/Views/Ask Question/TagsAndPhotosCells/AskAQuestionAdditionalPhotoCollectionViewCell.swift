//
//  AskAQuestionAdditionalPhotoCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/29/21.
//

import UIKit

class AskAQuestionAdditionalPhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: - properties
    
    static let identifier = "AskAQuestionAdditionalPhotoCollectionViewCell"
    
    //create configureation for photo picker
    
    private let addPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Photo"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let imageIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.tintColor = .label
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
        
        imageIcon.setDimensions(height: contentView.width - 80, width: contentView.width - 80)
        imageIcon.center(inView: contentView)
        
        addPhotoLabel.centerX(inView: imageIcon, topAnchor: imageIcon.bottomAnchor, paddingTop: 0)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    private func configure(){
        backgroundColor = .systemGray4
        layer.masksToBounds = true
        layer.cornerRadius = 25
        clipsToBounds = true
        
        contentView.addSubview(imageIcon)
        contentView.addSubview(addPhotoLabel)
    }
    
    
}
