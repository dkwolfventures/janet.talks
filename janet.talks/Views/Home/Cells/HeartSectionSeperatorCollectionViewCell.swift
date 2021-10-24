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
    
    let dividerLeft: UIView = {
        let v = UIView()
        v.backgroundColor = .label
        return v
    }()
    
    let dividerRight: UIView = {
        let v = UIView()
        v.backgroundColor = .label
        return v
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(dividerLeft)
        contentView.addSubview(heartIcon)
        contentView.addSubview(dividerRight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dividerLeft.centerY(inView: self)
        dividerLeft.anchor(left: contentView.leftAnchor, right: heartIcon.leftAnchor, paddingRight: 10, height: 0.5)
        heartIcon.center(inView: self)
        dividerRight.centerY(inView: self)
        dividerRight.anchor(left: heartIcon.rightAnchor, right: contentView.rightAnchor, paddingLeft: 10, height: 0.5)
    }
    
}
