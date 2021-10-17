//
//  PrivateChatTableViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/6/21.
//

import UIKit

class PrivateChatTableViewCell: UITableViewCell {
    
    //MARK: - properties
    
    static let identifier = "PrivateChatTableViewCell"
    
    private let featuredImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.isHidden = true
        return iv
    }()
    
    //MARK: - lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(featuredImage)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageHeight = contentView.height - 10
        featuredImage.frame = CGRect(x: 10, y: contentView.height/2 - (imageHeight/2), width: imageHeight, height: imageHeight)
        indentationLevel = 5
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.featuredImage.image = nil
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    public func configureForPublicQuestion(){
        
    }
    
    public func configureForPrivateChat(){
        featuredImage.isHidden = false
        featuredImage.image = UIImage(named: "test")
        textLabel?.text = "I think he's cheating"
        detailTextLabel?.text = "So, there I was minding my own business..."
    }
}
