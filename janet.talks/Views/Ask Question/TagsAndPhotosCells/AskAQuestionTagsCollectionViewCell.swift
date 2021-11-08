//
//  AskAQuestionTagsCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/29/21.
//

import UIKit

protocol AskAQuestionTagsCollectionViewCellDelegate: AnyObject {
    func tagsChanged(tags: String)
}

class AskAQuestionTagsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - properties
    
    static let identifier = "AskAQuestionTagsCollectionViewCell"
    
    weak var delegate: AskAQuestionTagsCollectionViewCellDelegate?
    
    private let helpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    public var tagsInput = TextInputWithTitle(title: "Tags", titleSize: 20, textFieldTextSize: 17, forTags: true)
    
    //MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagsInput)
        contentView.addSubview(helpButton)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tagsInput.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        
        helpButton.anchor(top: tagsInput.topAnchor, right: tagsInput.rightAnchor)
        helpButton.imageView?.setDimensions(height: 25, width: 25)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    //MARK: - actions
    
    @objc func didTapKeyboardDone() {
        tagsInput.textField.resignFirstResponder()
    }

    //MARK: - helpers
    private func configure(){
        tagsInput.textField.delegate = self
        tagsInput.textField.autocorrectionType = .no
        tagsInput.textField.keyboardType = .twitter
        tagsInput.textField.text = "#"
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 50))
        toolBar.items = [
            
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
            
        ]
        toolBar.sizeToFit()
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .topAttached)
        tagsInput.textField.inputAccessoryView = toolBar
    }
    
    public func configure(with tags: [String]?){
        
        if let tags = tags {
            tagsInput.textField.text = nil
            for tag in tags {
                tagsInput.textField.text.append("#" + tag)
            }
        }
    }
    
}

extension AskAQuestionTagsCollectionViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        if let lastChar = textView.text.last {
            if lastChar == " " {
                textView.text.append("#")
            } else if lastChar == "#" {
                if textView.text.count == 1 {
                    print("debug: deleting last ampersand..")
                }

            } else if !lastChar.isLetter {
                if !lastChar.isNumber {
                    textView.text.removeLast()
                }
            }
        }
        
        delegate?.tagsChanged(tags: textView.text.lowercased())
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if textView.text.last == "#" && text == "" {
            if textView.text.count == 0 {
                textView.text.append("#")
            }
            textView.text.removeLast()
        }
        
        if textView.text.last == "#" && text == "#" {
            textView.text.removeLast()
        }
        
        if textView.text.last == "#" && text == " " {
            textView.text.removeLast()
        }
        
        return true
    }
}
