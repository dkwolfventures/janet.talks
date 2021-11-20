//
//  PreviewQuestionPhotosCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/31/21.
//

import UIKit

class PreviewQuestionPhotosCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    
    static let identifier = "PreviewQuestionPhotosCollectionViewCell"
    
    var scView:UIScrollView!
    let buttonPadding:CGFloat = 10
    var xOffset:CGFloat = 10
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        scView = UIScrollView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: (contentView.width) / 2))
        addSubview(scView)
        
        scView.showsHorizontalScrollIndicator = false
        scView.backgroundColor = .none
        scView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        scView.contentSize = CGSize(width: xOffset, height: scView.frame.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        scView.reloadInputViews()
    }
    
    //MARK: - actions
    
    @objc private func tagTapped(_ sender: UIButton){
        print(sender.tag)
        
    }
    
    //MARK: - helpers
    
    public func configureButtons(viewModel: PreviewQuestionPhotosViewModel){
        
        if scView.subviews.count >= viewModel.photos.count {
            return
        }
        
        for i in 0 ... (viewModel.photos.count - 1) {
            
            let image = viewModel.photos[i]
                        
            let button = UIButton()
            button.setImage(image, for: .normal)
            button.layer.cornerRadius = 25
            button.imageView?.clipsToBounds = true
            button.imageView?.contentMode = .scaleAspectFill
            button.layer.masksToBounds = true
            button.tag = i
            button.addTarget(self, action: #selector(tagTapped(_:)), for: UIControl.Event.touchUpInside)
            
            let buttonWidth = (contentView.width) / 2
            
            var finalButtonSize: CGSize {
                
                switch image.size.width {
                case ...image.size.height:
                    return CGSize(width: buttonWidth/2, height: buttonWidth)
                    
                case image.size.height...:
                    return CGSize(width: buttonWidth, height: buttonWidth/2)
                  
                case image.size.height:
                    return CGSize(width: buttonWidth, height: buttonWidth)
                    
                default:
                    fatalError()
                }
                
            }
            
            let buttonSize = finalButtonSize
            
            if i == 0 {
                button.frame = CGRect(x: spacing, y: contentView.height/2 - buttonSize.height/2, width: buttonSize.width, height: buttonSize.height)
            } else {
                button.frame = CGRect(x: xOffset + 10, y: contentView.height/2 - buttonSize.height/2, width: buttonSize.width, height: buttonSize.height)
            }
            
            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
            scView.addSubview(button)
        }
    }
    
}
