//
//  TagView.swift
//  janet.talks
//
//  Created by Coding on 11/1/21.
//

import UIKit

class TagView: UIView {
    
    private var emojiLabel: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "xmark")
        iv.tintColor = .label
        return iv
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        
        addSubview(stackView)
        stackView.addArrangedSubview(emojiLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.bindToSuperview(8)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        emojiLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = 12
    }
    
    func setup(following: Bool, title: String) {
        titleLabel.text = title
        
        var isFollowing: UIImage {
            return following ? UIImage(systemName: "checkmark")! : UIImage(systemName: "xmark")!
        }
        
        if following {
            emojiLabel.tintColor = .systemGreen
        }
        
        emojiLabel.image = isFollowing
        
    }
}
