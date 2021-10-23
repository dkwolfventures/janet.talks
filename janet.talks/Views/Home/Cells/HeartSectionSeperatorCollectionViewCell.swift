//
//  HeartSectionSeperatorCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/22/21.
//

import UIKit

class HeartSectionSeperatorCollectionViewCell: UICollectionViewCell {
    
    //MARK: - properties
    
    static let identifier = "HeartSectionSeperatorCollectionViewCell"
    
    let heartIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .label
        iv.image = UIImage(systemName: "heart.fill")
        return iv
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.addSubview(heartIcon)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heartIcon.center(inView: self)
        
    }
    
}
