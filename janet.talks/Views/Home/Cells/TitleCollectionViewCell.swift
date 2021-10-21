//
//  TitleCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import UIKit

//MARK: - the cell height 205

class TitleCollectionViewCell: UICollectionViewCell {
    
    //MARK: - properties
    static let identifier = "TitleCollectionViewCell"
    
    private var index = 0
    
    private let featuredImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        featuredImageView.image = nil
        titleLabel.text = nil
        
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    func configure(with viewModel: TitleCollectionViewCellViewModel, index: Int){
        featuredImageView.image = viewModel.featuredImageUrl
    }
}
