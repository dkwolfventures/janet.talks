//
//  TextInputWithTitle.swift
//  janet.talks
//
//  Created by Coding on 10/4/21.
//

import UIKit

class TextInputWithTitle: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    private let textField: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .secondarySystemBackground
        tv.layer.cornerRadius = 8
        tv.layer.masksToBounds = true
        let view = UIView()
        view.setWidth(15)
        tv.textContainerInset = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
        return tv
    }()
    
    init(title: String){
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
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: titleLabel.height)
        
        textField.frame = CGRect(x: 0, y: titleLabel.bottom + 5, width: width, height: height - (titleLabel.height + 5))
    }
    
}
