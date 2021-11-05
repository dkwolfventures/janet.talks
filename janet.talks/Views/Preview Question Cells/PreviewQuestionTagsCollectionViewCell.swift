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
        
        scView = UIScrollView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 30))
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
        
        let button = scView.subviews[sender.tag] as! UIButton
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemGreen
        configuration.title = button.titleLabel?.text
        configuration.imagePadding = 10
        configuration.cornerStyle = .capsule
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.configuration = configuration
    }
    
    //MARK: - helpers
    
    public func configureButtons(viewModel: PreviewQuestionTagsViewModel){
        
        for i in 0 ... (viewModel.tags.count - 1) {
            
            if scView.subviews.count >= viewModel.tags.count {
                break
            }
            
            var configuration = UIButton.Configuration.filled()
            configuration.imagePadding = 10
            configuration.cornerStyle = .capsule
            configuration.baseForegroundColor = .label
            configuration.title = viewModel.tags[i]
            
            let button = UIButton()
            button.tag = i
            button.addTarget(self, action: #selector(tagTapped(_:)), for: UIControl.Event.touchUpInside)
            
            configuration.baseBackgroundColor = .systemBackground
            button.configuration = configuration
            
            let buttonSize = CGSize(width: CGFloat(50 + ( 11 * viewModel.tags[i].count)), height: 30)
            
            if i == 0 {
                button.frame = CGRect(x: spacing, y: 0, width: buttonSize.width, height: buttonSize.height)
            } else {
                button.frame = CGRect(x: xOffset + 10, y: 0, width: buttonSize.width, height: buttonSize.height)
            }
            
            button.setImage(UIImage(systemName: "xmark"), for: .normal)
            
            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
            scView.addSubview(button)
        }
    }
    
}
