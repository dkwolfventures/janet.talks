//
//  TextInputWithTitle.swift
//  janet.talks
//
//  Created by Coding on 10/4/21.
//

import UIKit

class TextInputWithTitle: UIView {
    
    private var titleSize: CGFloat = 0
    private var textfieldTextSize: CGFloat = 0
    private var paddingFromTop: CGFloat = 0
    private var numberOfLines: Int? = nil
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    public let textField: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .systemBackground
        tv.layer.cornerRadius = 25
        tv.layer.masksToBounds = true
        tv.font = .systemFont(ofSize: 19, weight: .semibold)
        let view = UIView()
        view.setWidth(15)
        tv.textContainerInset = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
        return tv
    }()
    
    init(title: String, titleSize: CGFloat, textFieldTextSize: CGFloat, paddingFromTop: CGFloat, numberOfLines: Int? = nil){
        self.titleSize = titleSize
        self.textfieldTextSize = textFieldTextSize
        self.paddingFromTop = paddingFromTop
        self.numberOfLines = numberOfLines
        super.init(frame: .zero)
        titleLabel.text = title
        addSubview(titleLabel)
        addSubview(textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let numberOfLines = numberOfLines {
            textField.textContainer.maximumNumberOfLines = numberOfLines
        }
        
        titleLabel.font = .systemFont(ofSize: titleSize, weight: .bold)
        textField.font = .systemFont(ofSize: textfieldTextSize, weight: .semibold)
        
        textField.textContainerInset = UIEdgeInsets(top: paddingFromTop, left: spacing, bottom: 0, right: spacing)
        
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: titleLabel.height)
        
        textField.frame = CGRect(x: 0, y: titleLabel.bottom + 5, width: width, height: height - (titleLabel.height + 5))
    }
    
}
