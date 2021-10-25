//
//  AskAQuestionTableViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/24/21.
//

import UIKit

class AskAQuestionTableViewCell: UITableViewCell {

    //MARK: - properties
    static let identifier = "AskAQuestionTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        return label
    }()
    
    private let checkMarkIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.circle")
        iv.tintColor = .systemGray4
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    //MARK: - lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkMarkIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.sizeToFit()
        let iconSize: CGFloat = 40
        
        titleLabel.frame = CGRect(x: spacing, y: height/2 - titleLabel.height/2, width: contentView.width - (spacing * 2) - (iconSize + 10), height: titleLabel.height)
        checkMarkIcon.centerY(inView: titleLabel)
        checkMarkIcon.anchor(right: contentView.rightAnchor, paddingRight: spacing, width: iconSize, height: iconSize)
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        checkMarkIcon.image = nil
    }
    
    //MARK: - helpers

    public func configure(cellTitle: String){
        titleLabel.text = cellTitle
    }
}
