//
//  PosterAndActionsCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/20/21.
//

import UIKit
import Kingfisher

protocol PosterAndActionsCollectionViewCellDelegate: AnyObject {
    func loveButtonTapped(_ cell: PosterAndActionsCollectionViewCell, isLoved: Bool, index: Int)
}

class PosterAndActionsCollectionViewCell: UICollectionViewCell {
    //MARK: - properties
    static let identifier = "PosterAndActionsCollectionViewCell"
    
    weak var delegate: PosterAndActionsCollectionViewCellDelegate?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .secondarySystemFill
        iv.tintColor = .secondaryLabel
        iv.layer.borderColor = UIColor.systemBackground.cgColor
        iv.layer.borderWidth = 5
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let qAskedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let questionAskedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(questionAskedLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing = contentView.width/20
        let imageSize: CGFloat = contentView.height - 20
        profileImageView.frame = CGRect(x: spacing, y: 0, width: imageSize, height: imageSize)
        profileImageView.layer.cornerRadius = imageSize/2
        
        usernameLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: spacing/2)
        
        questionAskedLabel.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, paddingTop: 4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        usernameLabel.text = nil
        qAskedLabel.text = nil
    
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    func configure(with viewModel: ActionsCollectionViewCellViewModel, index: Int){
        
        let url = URL(string: viewModel.profileImageUrl)
        let processor = DownsamplingImageProcessor(size: profileImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: profileImageView.width/2)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: viewModel.profileImageUrl),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            [weak self, profileImageView] result in
            
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                
                if profileImageView.image == nil {
                    self?.configure(with: viewModel, index: index)
                }
                
                print("Job failed: \(error.localizedDescription)")
            }
        }
        
        usernameLabel.text = "@" + viewModel.username
        
        questionAskedLabel.text = "\(viewModel.qsAsked) Qs Asked"

    }
}
