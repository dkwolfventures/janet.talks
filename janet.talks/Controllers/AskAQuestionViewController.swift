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
        view.backgroundColor = .none
        view.addSubview(mainView)
        view.addSubview(closeButtonBackground)
        view.addSubview(closeButton)
        mainView.addSubview(titleLabel)
        
    }
    
    //MARK: - lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let mainFrameHeight: CGFloat = view.height - 80
        let mainFrameWidth: CGFloat = view.width - 80
        mainView.frame = CGRect(x: view.width/2 - (mainFrameWidth/2), y: view.height/1.75 - (mainFrameHeight/2), width: mainFrameWidth, height: mainFrameHeight/2)
        mainView.layer.borderColor = UIColor.label.cgColor
        
        closeButtonBackground.frame = CGRect(x: mainView.left - 10, y: mainView.top - 10, width: 30, height: 30)
        closeButton.frame = CGRect(x: mainView.left - 10, y: mainView.top - 10, width: 30, height: 30)

        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 0, y: 8, width: mainView.width, height: titleLabel.height)
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
