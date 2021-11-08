//
//  PreviewQuestionTitleCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/31/21.
//

import UIKit

class PreviewQuestionTitleCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    
    static let identifier = "PreviewQuestionTitleCollectionViewCell"
    
    private var index = 0
    
    private let featuredImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.image = UIImage(named: "featuredPlaceholder")
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 25
        contentView.layer.masksToBounds = true
        contentView.addSubview(featuredImageView)
        contentView.addSubview(titleLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing = contentView.width/20
        featuredImageView.frame = CGRect(x: spacing, y: 10, width: contentView.height - 20, height: contentView.height - 20)
        
        titleLabel.anchor(top: featuredImageView.topAnchor, left: featuredImageView.rightAnchor, right: contentView.rightAnchor, paddingLeft: spacing, paddingRight: spacing)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        featuredImageView.image = nil
        titleLabel.text = nil
        
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    func configure(with viewModel: PreviewQuestionTitleViewModel){
        
        featuredImageView.image = viewModel.featuredImageUrl
        titleLabel.text = viewModel.subject
        
    }
}
