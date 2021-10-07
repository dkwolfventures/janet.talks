//
//  MyQuestionsTableViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import UIKit

class MyQuestionsTableViewCell: UITableViewCell {
    
    //MARK: - properties
    
    static let identifier = "MyQuestionsTableViewCell"
    
    private let featuredImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.isHidden = true
        return iv
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let viewsLabel: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "eye")
        iv.tintColor = .label
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    //MARK: - lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(featuredImage)
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageHeight = contentView.height - 10
        featuredImage.frame = CGRect(x: 10, y: contentView.height/2 - (imageHeight/2), width: imageHeight, height: imageHeight)
        
        let dateLabelWidth: CGFloat = (contentView.width) - 10
        dateLabel.frame = CGRect(x: contentView.width - dateLabelWidth - 20, y: 5, width: dateLabelWidth, height: 15)
        
        textLabel?.frame = CGRect(x: textLabel!.left, y: detailTextLabel!.top - (textLabel!.height - 5), width: textLabel!.width, height: textLabel!.height)
        
        detailTextLabel?.frame = CGRect(x: textLabel!.left, y: contentView.bottom - (detailTextLabel!.height + 5), width: detailTextLabel!.width, height: detailTextLabel!.height)
        
        indentationLevel = 1
        indentationWidth = imageHeight
        
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
        textLabel?.text = "help! what do i do??"
        detailTextLabel?.text = "So, there I was minding my own business and then his phone starting going off with some number i didn't know"
        dateLabel.text = DateFormatter.formatter.string(from: Date()).lowercased()
    }
}
