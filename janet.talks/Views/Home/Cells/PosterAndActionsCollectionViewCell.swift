//
//  PosterAndActionsCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/20/21.
//

import UIKit
import Kingfisher

class PosterAndActionsCollectionViewCell: UICollectionViewCell {
    //MARK: - properties
    static let identifier = "PosterAndActionsCollectionViewCell"
    
    private var isLoved = false

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "profilePlaceholder")
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
        let imageSize: CGFloat = contentView.height - 20 - 15
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
        
        loveButton.imageView?.image = UIImage(systemName: "heart")
        loveButton.tintColor = .label
    }
    
    //MARK: - actions
    
    @objc private func loveButtonTapped(){
        
        if isLoved {
            self.isLoved = false
            loveButton.setImage(UIImage(systemName: "heart"), for: .normal)
            loveButton.tintColor = .label
            self.love -= 1
        } else {
            self.isLoved = true
            loveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            loveButton.tintColor = .systemRed
            self.love += 1
        }
        
    }
    
    //MARK: - helpers
    
    func configure(with viewModel: ActionsCollectionViewCellViewModel, index: Int){
        
        profileImageView.image = UIImage(named: "profilePlaceholder")
        
        self.love = CGFloat(viewModel.postLovers)
        self.comments = CGFloat(viewModel.comments)
        self.shares = CGFloat(viewModel.shares)
        
//        let processor = DownsamplingImageProcessor(size: profileImageView.bounds.size)
//        |> RoundCornerImageProcessor(cornerRadius: profileImageView.width/2)
//        profileImageView.kf.indicatorType = .activity
//        profileImageView.kf.setImage(
//            with: viewModel.profileImageUrl,
//            placeholder: UIImage(named: "placeholderImage"),
//            options: [
//                .processor(processor),
//                .scaleFactor(UIScreen.main.scale),
//                .transition(.fade(1)),
//                .cacheOriginalImage
//            ])
//        {
//            result in
//            switch result {
//            case .success(let value):
//                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//            case .failure(let error):
//                print("Job failed: \(error.localizedDescription)")
//            }
//        }
        
        self.isLoved = viewModel.isLoved
        
        if viewModel.isLoved {
            loveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            loveButton.tintColor = .systemRed
        }
        
        var loveCount: String {
            return viewModel.postLovers >= 1000 ? "\(love)" : "\(Int(love))"
        }
        
        usernameLabel.text = viewModel.username
        loveAmount.text = loveCount
        commentAmount.text = "\(comments)"
        shareAmount.text = "\(shares)"
        
        questionAskedLabel.text = "\(viewModel.qsAsked) Qs Asked"

    }
}
