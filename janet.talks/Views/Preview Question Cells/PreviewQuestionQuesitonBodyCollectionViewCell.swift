//
//  PreviewQuestionQuesitonBodyCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/31/21.
//

import UIKit

class PreviewQuestionQuesitonBodyCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    
    static let identifier = "PreviewQuestionQuesitonBodyCollectionViewCell"
    
    private let questionBodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let readMoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.setTitle("read more", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor( .secondaryLabel, for: .normal)
        button.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 25
        contentView.layer.masksToBounds = true
        contentView.addSubview(questionBodyLabel)
        contentView.addSubview(readMoreButton)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing = contentView.width/20
        
        questionBodyLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: readMoreButton.topAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: spacing, paddingRight: spacing)
        
        readMoreButton.anchor(left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, height: 45)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        questionBodyLabel.text = nil
    }
    
    //MARK: - actions
    
    @objc private func readMoreButtonTapped(){
        
    }
    
    //MARK: - helpers
    
    func configure(with viewModel: PreviewQuestionQuestionBodyViewModel){
        questionBodyLabel.text = viewModel.question
    }
}
