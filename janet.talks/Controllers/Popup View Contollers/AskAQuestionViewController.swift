//
//  AskAQuestionViewController.swift
//  janet.talks
//
//  Created by Coding on 10/4/21.
//

import UIKit

protocol AskAQuestionDelegate: AnyObject{
    func closeAskAQuestion(_ vc: AskAQuestionViewController)
}

class AskAQuestionViewController: UIViewController {
    
    //MARK: - properties
    private var isPublicPost: Bool = true
    
    weak var delegate: AskAQuestionDelegate?
    
    private let closeButtonBackground = SystemIconButton(iconName: "circle.fill", iconColor: .systemRed)
    private let closeButton = SystemIconButton(iconName: "xmark.circle.fill")
    
    private let mainView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 8
        v.layer.masksToBounds = true
        v.layer.borderWidth = 2
        return v
    }()
    
    private let subjectTextField = TextInputWithTitle(title: "subject")
    private let situationTextField = TextInputWithTitle(title: "question")
    private let questionTextField = TextInputWithTitle(title: "background (optional)")
    private let publicOrPrivate = PublicQuestionOrPrivateChat(frame: .zero)
//    private let sendQuestionButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("send question", for: .normal)
//        button.tintColor = .label
//        button.layer.cornerRadius = 8
//        return button
//    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [subjectTextField, situationTextField, questionTextField, publicOrPrivate])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    private let titleLabel: UILabel =  {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = "ask a question"
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        
        publicOrPrivate.delegate = self
        
        view.backgroundColor = .none
        view.addSubview(mainView)
        view.addSubview(closeButtonBackground)
        view.addSubview(closeButton)
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(stack)
        
    }
    
    //MARK: - lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let mainFrameHeight: CGFloat = view.height - 80
        let mainFrameWidth: CGFloat = view.width - 80
        mainView.frame = CGRect(x: view.width/2 - (mainFrameWidth/2), y: view.height/1.75 - (mainFrameHeight/2), width: mainFrameWidth, height: mainFrameHeight/2)
        mainView.layer.borderColor = UIColor.label.cgColor
        
        let buttonSize: CGFloat = 35
        
        closeButtonBackground.frame = CGRect(x: mainView.left - 13, y: mainView.top - 13, width: buttonSize, height: buttonSize)
        closeButton.frame = CGRect(x: mainView.left - 13, y: mainView.top - 13, width: buttonSize, height: buttonSize)

        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 0, y: 8, width: mainView.width, height: titleLabel.height)
        
        let stackWidth: CGFloat = mainView.width - 40
        let stackHeight: CGFloat = (mainView.height - titleLabel.height) - CGFloat((8 * stack.subviews.count))
        stack.frame = CGRect(x: mainView.width/2 - (stackWidth/2), y: titleLabel.bottom + 5, width: stackWidth, height: stackHeight)
    }
    
    //MARK: - actions
    
    @objc private func didTapClose(){
        delegate?.closeAskAQuestion(self)
    }
    
    //MARK: - helpers
    
    private func configureButtons(){
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
}

//MARK: - PublicQuestionOrPrivateChatDelegate

extension AskAQuestionViewController: PublicQuestionOrPrivateChatDelegate{
    func didChoosePublicOrPrivate(_ isPublic: Bool) {
        
        self.isPublicPost = isPublic
        
        switch isPublic {
        case true:
            print("debug: THIS POST IS SO PUBLIC!")
            
        case false:
            print("debug: shhhhhh this is private")
        }
    }
}
