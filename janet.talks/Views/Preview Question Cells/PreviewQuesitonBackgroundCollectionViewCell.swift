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
    
    //MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    public func configure(with viewModel: PreviewQuestionBackgroundViewModel) {
        
    }
}
