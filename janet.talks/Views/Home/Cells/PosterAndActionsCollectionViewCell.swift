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
    
    private var isLoved = false
    private var index = 0
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .secondarySystemFill
        iv.tintColor = .secondaryLabel
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
    
    private let loveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let loveAmount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let commentAmount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let shareAmount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let questionAskedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private var love: CGFloat = 0
    private var comments: CGFloat = 0
    private var shares: CGFloat = 0

    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 25
        contentView.layer.masksToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(loveButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(loveAmount)
        contentView.addSubview(commentAmount)
        contentView.addSubview(shareAmount)
        contentView.addSubview(questionAskedLabel)
        
        loveButton.addTarget(self, action: #selector(loveButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing = contentView.width/20
        let imageSize: CGFloat = contentView.height - 20 - 15 - 5
        let buttonIconSize: CGFloat = 35
        profileImageView.frame = CGRect(x: spacing, y: 10, width: imageSize, height: imageSize)
        profileImageView.layer.cornerRadius = imageSize/2
        
        usernameLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: spacing/2)
        usernameLabel.anchor(right: loveButton.rightAnchor, paddingRight: 5)
        
        shareButton.anchor(top: profileImageView.topAnchor, right: contentView.rightAnchor, paddingRight: spacing)
        shareButton.imageView?.setDimensions(height: buttonIconSize, width: buttonIconSize)
        
        commentButton.centerY(inView: shareButton)
        commentButton.imageView?.setDimensions(height: buttonIconSize, width: buttonIconSize)
        commentButton.anchor(right: shareButton.leftAnchor, paddingRight: 10)
        
        loveButton.centerY(inView: shareButton)
        loveButton.imageView?.setDimensions(height: buttonIconSize, width: buttonIconSize)
        loveButton.anchor(right: commentButton.leftAnchor, paddingRight: 10)
        
        loveAmount.centerX(inView: loveButton, topAnchor: loveButton.bottomAnchor, paddingTop: 4)
        commentAmount.centerX(inView: commentButton, topAnchor: commentButton.bottomAnchor, paddingTop: 4)
        shareAmount.centerX(inView: shareButton, topAnchor: shareButton.bottomAnchor, paddingTop: 4)
        
        questionAskedLabel.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, paddingTop: 4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        usernameLabel.text = nil
        qAskedLabel.text = nil
        loveAmount.text = nil
        commentAmount.text = nil
        shareAmount.text = nil
        
        loveButton.imageView?.image = nil
        loveButton.tintColor = .label
    }
    
    //MARK: - actions
    
    @objc private func loveButtonTapped(){
        if self.isLoved {
            let image = UIImage(systemName: "suit.heart")
            loveButton.setImage(image, for: .normal)
            loveButton.tintColor = .label
        }
        else {
            let image = UIImage(systemName: "suit.heart.fill")
            loveButton.setImage(image, for: .normal)
            loveButton.tintColor = .systemRed
        }
        
        delegate?.loveButtonTapped(self,
                                   isLoved: !isLoved,
                                   index: index)
        self.isLoved = !isLoved
    }
    
    //MARK: - helpers
    
    func configure(with viewModel: ActionsCollectionViewCellViewModel, index: Int){
        
        self.love = CGFloat(viewModel.postLovers.count)
        self.comments = CGFloat(viewModel.comments)
        self.shares = CGFloat(viewModel.shares)
        
        self.index = index
        
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
        
        self.isLoved = viewModel.isLoved
        
        if viewModel.isLoved {
            loveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            loveButton.tintColor = .systemRed
        }
        
        var loveCount: String {
            return viewModel.postLovers.count >= 1000 ? "\(love)" : "\(Int(love))"
        }
        
        var commentCount: String {
            return viewModel.postLovers.count >= 1000 ? "\(comments)" : "\(Int(comments))"
        }
        
        var shareCount: String {
            return viewModel.postLovers.count >= 1000 ? "\(shares)" : "\(Int(shares))"
        }
        
        usernameLabel.text = "@" + viewModel.username
        loveAmount.text = "\(viewModel.postLovers.count)"
        commentAmount.text = commentCount
        shareAmount.text = shareCount
        
        questionAskedLabel.text = "\(viewModel.qsAsked) Qs Asked"

    }
}
