//
//  SignUpViewController.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: - properties
    
    public var completion: (() -> Void)?
    private var firstResp: UITextField?
    
    private let logoView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerCurve = .continuous
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let usernameTextField = AuthField(.username)
    private let emailTextField = AuthField(.email)
    private let passwordTextField = AuthField(.password)
    private let signUpButton = AuthButton(.signUp)
    private let termsButton = AuthButton(.plain, title: "Terms of Service")
    
    private lazy var stack = UIStackView(arrangedSubviews:
                                            [usernameTextField,
                                             emailTextField,
                                             passwordTextField,
                                             signUpButton,
                                             termsButton])
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        view.addSubview(logoView)
        
        configureFields()
        configureButtons()

        view.addSubview(stack)
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let logoSize = CGSize(width: 200, height: 200)
        logoView.frame = CGRect(x: view.width/2 - (logoSize.width/2), y: view.safeAreaInsets.top, width: logoSize.width, height: logoSize.height)
        
        let stackWidth = view.width - 60
        let stackCount = CGFloat(stack.subviews.count)
        let stackSectionHeight: CGFloat = stackCount * 60 + (stackCount - 1 * 12)
        stack.frame = CGRect(x: view.width/2 - (stackWidth / 2), y: logoView.bottom, width: stackWidth, height: stackSectionHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameTextField.becomeFirstResponder()
    }
    
    //MARK: - actions
    
    @objc private func didTapSignIn(){
        
        hideKeyboard()
        
        
    }
    
    @objc private func didTapSignUp(){
        hideKeyboard()
        
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        let authCreds = AuthCredentials(username: username, email: email, password: password)
        
        if authCreds.usernameIsSafe().0
            && authCreds.isValidEmail().0
            && authCreds.passwordIsSafe().0 {
            
        } else {
            
        }
        
//        guard let username = usernameTextField.text,
//              let email = emailTextField.text,
//              let password = passwordTextField.text,
//              !username.trimmingCharacters(in: .whitespaces).isEmpty,
//              !email.trimmingCharacters(in: .whitespaces).isEmpty,
//              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
//                  let alert = UIAlertController(title: "Blank Spaces", message: "That should only be a Taylor Swift song. Please make sure all the .\nThank you\n- Management", preferredStyle: .alert)
//                  alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//                  present(alert, animated: true)
//
//                  return
//              }
        
//        AuthenticationManager.shared.signIn(email: email, password: password) { [weak self] success in
//            switch success {
//            case true:
//                self?.dismiss(animated: true)
//            case false:
//                break
//            }
//        }
        
    }
    
    @objc private func didTapForgotPassword(){
        hideKeyboard()
        
    }
    
    //MARK: - helpers
    
    private func hideKeyboard(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    private func configureFields(){
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func configureButtons(){
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
