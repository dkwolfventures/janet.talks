//
//  AskQuestionSituationOrBackgroundViewController.swift
//  janet.talks
//
//  Created by Coding on 10/26/21.
//

import Foundation
import UIKit

protocol AskQuestionSituationOrBackgroundViewControllerDelegate: AnyObject {
    func addBackgroundInfo(background: String)
}

class AskQuestionSituationOrBackgroundViewController: UIViewController {
    //MARK: - properties
    let incomingQuestion: PublicQuestionToAdd
    var keyboardHeight = CGFloat()
    
    weak var delegate: AskQuestionSituationOrBackgroundViewControllerDelegate?
    
    private lazy var backgroundTextView = TextInputWithTitle(title: "Background:", titleSize: 20, textFieldTextSize: 17)
    
    private let helpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    //MARK: - lifecycle
    
    init(question: PublicQuestionToAdd){
        self.incomingQuestion = question
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundTextView.textField.becomeFirstResponder()
        registerNotification()
        configureTextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        title = "Background Info"
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        helpButton.imageView?.setDimensions(height: 25, width: 25)
        helpButton.anchor(top: backgroundTextView.topAnchor, right: backgroundTextView.rightAnchor)
        
        backgroundTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: view.spacing, paddingLeft: view.spacing, paddingBottom: keyboardHeight - view.spacing, paddingRight: view.spacing)
    }
    
    //MARK: - actions
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.keyboardHeight = keyboardHeight
            
        }
    }
    
    @objc private func addQuestion(){
        
        guard let backgroundInfo = backgroundTextView.textField.text else {
            return
        }
        
        if backgroundInfo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert("Please enter some real content...")
            return
        } else if backgroundInfo.trimmingCharacters(in: .whitespacesAndNewlines).count < 100 {
            showAlert("Please expand on the situation to make things more clear for the readers.")
            return
        }
        
        navigationController?.popViewController(animated: true)
        delegate?.addBackgroundInfo(background: backgroundInfo)
        
    }
    
    //MARK: - helpers
    
    private func showAlert(_ message: String){
        let alert = UIAlertController(title: "Uh Oh!", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func configureTextView(){
        if let background = incomingQuestion.situationOrBackground {
            backgroundTextView.textField.text = background
        }
    }
    
    private func configureNavigation(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(addQuestion))
    }
    
    private func addSubviews(){
        view.addSubview(helpButton)
        view.addSubview(backgroundTextView)
    }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
}
