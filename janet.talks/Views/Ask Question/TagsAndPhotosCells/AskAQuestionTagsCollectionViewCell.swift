//
//  AskAQuestionTagsCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/29/21.
//

import UIKit

class AskAQuestionTagsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - properties
    
    static let identifier = "AskAQuestionTagsCollectionViewCell"
    
    private var tagsInput = TextInputWithTitle(title: "Tags", titleSize: 20, textFieldTextSize: 17)
    
    //MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagsInput)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tagsInput.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    private func configure(){
        tagsInput.textField.insertTextPlaceholder(with: tagsInput.frame.size)
    }
    
    
}
