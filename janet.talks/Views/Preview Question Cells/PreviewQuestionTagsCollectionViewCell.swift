//
//  PreviewQuestionTagsCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/31/21.
//

import UIKit

class PreviewQuestionTagsCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    
    static let identifier = "PreviewQuestionTagsCollectionViewCell"
    
    var scView:UIScrollView!
    let buttonPadding:CGFloat = 10
    var xOffset:CGFloat = 10
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        scView = UIScrollView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: contentView.height))
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
        
        let button = scView.subviews[sender.tag] as! TagButton
        
        switch button.following {
        case true:
            button.following = false
            button.configureForNotFollowed()
        case false:
            button.following = true
            button.configureForFollowed()
        }
    }
    
    //MARK: - helpers
    
    public func configureButtons(viewModel: PreviewQuestionTagsViewModel){
        
        if scView.subviews.count >= viewModel.tags.count {
            return
        }
        
        for i in 0 ... (viewModel.tags.count - 1) {
            
            let buttonTitle = viewModel.tags[i]
            
            let button = TagButton(title: buttonTitle, following: false)
            button.tag = i
            button.addTarget(self, action: #selector(tagTapped(_:)), for: UIControl.Event.touchUpInside)
            
            let font: UIFont = .systemFont(ofSize: 18)
            let fontAttributes = [NSAttributedString.Key.font: font]
            
            let buttonSize = CGSize(width: (viewModel.tags[i] as NSString).size(withAttributes: fontAttributes).width + 65, height: contentView.height)
            
            if i == 0 {
                button.frame = CGRect(x: spacing, y: 0, width: buttonSize.width, height: buttonSize.height)
            } else {
                button.frame = CGRect(x: xOffset + 10, y: 0, width: buttonSize.width, height: buttonSize.height)
            }
            
            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
            scView.addSubview(button)
        }
    }
    
}
