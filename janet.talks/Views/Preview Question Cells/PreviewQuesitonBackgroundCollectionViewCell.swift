//
//  PreviewQuesitonBackgroundCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/31/21.
//

import UIKit

class PreviewQuesitonBackgroundCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    
    static let identifier = "PreviewQuesitonBackgroundCollectionViewCell"
    
    private let backgroundBodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let bLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 27, weight: .heavy)
        label.textColor = .secondaryLabel
        label.text = "B:"
        return label
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.layer.cornerRadius = 25
        contentView.layer.masksToBounds = true
        contentView.addSubview(backgroundBodyLabel)
        contentView.addSubview(bLabel)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: spacing)
              
        backgroundBodyLabel.anchor(top: bLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: spacing, paddingBottom: 10, paddingRight: spacing)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundBodyLabel.text = nil
    }
    
    //MARK: - actions
    
    @objc private func readMoreButtonTapped(){
        
    }
    
    //MARK: - helpers
    
    func configure(with viewModel: PreviewQuestionBackgroundViewModel){
        
        contentView.backgroundColor = .systemBackground
        backgroundBodyLabel.text = viewModel.background
    }
}
