//
//  TitleCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import UIKit
import Kingfisher

//MARK: - the cell height 205

class TitleCollectionViewCell: UICollectionViewCell {
    
    //MARK: - properties
    static let identifier = "TitleCollectionViewCell"
    
    private var index = 0
    
    private let featuredImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        label.textAlignment = .left
        return label
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 25
        contentView.layer.masksToBounds = true
        contentView.addSubview(featuredImageView)
        contentView.addSubview(titleLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing = contentView.width/20
        featuredImageView.frame = CGRect(x: spacing, y: 10, width: contentView.height - 20, height: contentView.height - 20)
        
        titleLabel.anchor(top: featuredImageView.topAnchor, left: featuredImageView.rightAnchor, right: contentView.rightAnchor, paddingLeft: 10, paddingRight: spacing)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        featuredImageView.image = nil
        titleLabel.text = nil
        
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    func configure(with viewModel: TitleCollectionViewCellViewModel, index: Int){
        
        titleLabel.text = viewModel.subject.capitalized
        
        let url = URL(string: viewModel.featuredImageUrl)
        let processor = DownsamplingImageProcessor(size: featuredImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 25)
        featuredImageView.kf.indicatorType = .activity
        featuredImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: viewModel.featuredImageUrl),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            [weak self, featuredImageView] result in
            
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                
                if featuredImageView.image == nil {
                    self?.configure(with: viewModel, index: index)
                }
                
                print("Job failed: \(error.localizedDescription)")
            }
        }
        
    }
}
