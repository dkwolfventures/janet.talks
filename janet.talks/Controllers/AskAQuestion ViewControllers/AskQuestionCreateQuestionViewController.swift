//
//  AskQuestionCreateQuestionViewController.swift
//  janet.talks
//
//  Created by Coding on 10/26/21.
//

import Foundation
import UIKit
import SwiftUI

protocol AskQuestionCreateQuestionViewControllerDelegate: AnyObject {
    func addQuestion(question: String)
}

class AskQuestionCreateQuestionViewController: UIViewController {
    //MARK: - properties
    let incomingQuestion: PublicQuestionToAdd
    var keyboardHeight = CGFloat()
    
    weak var delegate: AskQuestionCreateQuestionViewControllerDelegate?
    
    private lazy var questionTextView = TextInputWithTitle(title: "Question:", titleSize: 20, textFieldTextSize: 17)
    
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
        questionTextView.textField.becomeFirstResponder()
        registerNotification()
        configureTextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        title = "Create Your Question"
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        questionTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: view.spacing, paddingLeft: view.spacing, paddingBottom: keyboardHeight - view.spacing, paddingRight: view.spacing)
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
        
        guard let question = questionTextView.textField.text else {
            return
        }
        
        if question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert("Blank Spaces should only be a Taylor Swift song, not a question. Enter some real content!")
            return
        } else if question.trimmingCharacters(in: .whitespacesAndNewlines).count < 100 {
            showAlert("Please expand on the qustion. The more specific you are, the better answers you will receive!")
            return
        }
        
        navigationController?.popViewController(animated: true)
        delegate?.addQuestion(question: question)
        
    }
    
    //MARK: - helpers
    
    private func showAlert(_ message: String){
        let alert = UIAlertController(title: "Uh Oh!", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func configureTextView(){
        if let q = incomingQuestion.question {
            questionTextView.textField.text = q
        }
    }
    
    private func configureNavigation(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(addQuestion))
    }
    
    private func addSubviews(){
        view.addSubview(questionTextView)
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
