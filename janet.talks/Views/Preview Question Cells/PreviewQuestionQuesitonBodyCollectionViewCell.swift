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
    
    private let qLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 27, weight: .heavy)
        label.textColor = .secondaryLabel
        label.text = "Q:"
        return label
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 25
        contentView.layer.masksToBounds = true
        contentView.addSubview(questionBodyLabel)
        contentView.addSubview(qLabel)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        qLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: spacing)
              
        questionBodyLabel.anchor(top: qLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: spacing, paddingRight: spacing)
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
