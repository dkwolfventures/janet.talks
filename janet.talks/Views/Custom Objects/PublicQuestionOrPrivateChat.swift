//
//  PublicQuestionOrPrivateChat.swift
//  janet.talks
//
//  Created by Coding on 10/4/21.
//

import UIKit

protocol PublicQuestionOrPrivateChatDelegate: AnyObject {
    func didChoosePublicOrPrivate(_ isPublic: Bool)
}

class PublicQuestionOrPrivateChat: UIView {
    
    //MARK: - properties
    
    private var isPublic: Bool = true
    
    weak var delegate: PublicQuestionOrPrivateChatDelegate?
    
    private let publicCircle: UIView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "circle.fill")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let publicLabel: UILabel = {
        let label = UILabel()
        label.text = "public question"
        label.textColor = .label
        return label
    }()
    
    private let privateLabel: UILabel = {
        let label = UILabel()
        label.text = "private chat"
        label.textColor = .label
        return label
    }()
    
    private let privateCircle: UIView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "circle.fill")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [publicCircle, privateCircle])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let isPublicActiveCircle: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.image = UIImage(systemName: "circle.fill")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBackground
        iv.clipsToBounds = true
        return iv
    }()
    
    private let isPrivateActiveCircle: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.image = UIImage(systemName: "circle.fill")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBackground
        iv.isHidden = true
        iv.alpha = 0
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewTargets()
        addSubview(stack)
        addSubview(publicLabel)
        addSubview(privateLabel)
        publicCircle.addSubview(isPublicActiveCircle)
        privateCircle.addSubview(isPrivateActiveCircle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        publicLabel.sizeToFit()
        privateLabel.sizeToFit()
        
        stack.frame = CGRect(x: 0 , y: 0, width: width, height: height - publicLabel.height)
        isPublicActiveCircle.center(inView: publicCircle)
        isPublicActiveCircle.setDimensions(height: publicCircle.height - 15, width: publicCircle.width - 15)
        isPrivateActiveCircle.center(inView: privateCircle)
        isPrivateActiveCircle.setDimensions(height: privateCircle.height - 15, width: privateCircle.width - 15)
        publicLabel.centerX(inView: publicCircle, topAnchor: publicCircle.bottomAnchor)
        privateLabel.centerX(inView: privateCircle, topAnchor: privateCircle.bottomAnchor)
    }
    
    //MARK: - actions
    
    @objc private func didTapPublicPost(_ tappedView: UIView){
        if !isPublic {
            isPublicActiveCircle.isHidden = false
            UIView.animate(withDuration: 0.15) { [weak self]  in
                self?.isPrivateActiveCircle.alpha = 0
                self?.isPublicActiveCircle.alpha = 1
            } completion: {done in
                if done {
                    self.privateCircle.isUserInteractionEnabled = true
                    self.publicCircle.isUserInteractionEnabled = true
                    self.isPrivateActiveCircle.isHidden = true
                    self.isPublic = true
                    self.delegate?.didChoosePublicOrPrivate(true)
                }
            }
        }
        
    }
    
    @objc private func didTapPrivatePost(_ tappedView: UIView){
        if isPublic {
            isPrivateActiveCircle.isHidden = false
            UIView.animate(withDuration: 0.15) { [weak self]  in
                self?.isPublicActiveCircle.alpha = 0
                self?.isPrivateActiveCircle.alpha = 1
            } completion: {done in
                if done {
                    self.publicCircle.isUserInteractionEnabled = true
                    self.privateCircle.isUserInteractionEnabled = true
                    self.isPublicActiveCircle.isHidden = true
                    self.isPublic = false
                    self.delegate?.didChoosePublicOrPrivate(false)
                }
            }
        }
        
        
    }
    
    //MARK: - helpers
    
    
    private func configureViewTargets(){
        let publictap = UITapGestureRecognizer(target: self, action: #selector(didTapPublicPost(_:)))
        let privatetap = UITapGestureRecognizer(target: self, action: #selector(didTapPrivatePost(_:)))
        publicCircle.addGestureRecognizer(publictap)
        privateCircle.addGestureRecognizer(privatetap)
    }

}
