//
//  SignInViewController.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import UIKit

class SignInViewController: UIViewController {
    
    //MARK: - properties
    private var firstResp: UITextField?
    
    private let logoView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerCurve = .continuous
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let emailTextField = AuthField(.email)
    private let passwordTextField = AuthField(.password)
    private let signInButton = AuthButton(.signIn)
    private let forgotPasswordButton = AuthButton(.plain, title: "Forgot Password")
    private let signUpButton = AuthButton(.plain, title: "New User? Create Account")

    private lazy var stack = UIStackView(arrangedSubviews:
                                            [emailTextField,
                                             passwordTextField,
                                             signInButton,
                                             forgotPasswordButton,
                                             signUpButton])
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
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
        
        emailTextField.becomeFirstResponder()
    }
    
    //MARK: - actions
    
    @objc private func didTapSignIn(){
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
                  let alert = UIAlertController(title: "Blank Spaces", message: "That should only be a Taylor Swift song. Please make sure you have a valid email and password in the text fields.\nThank you\n- Management", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                  present(alert, animated: true)
                  
                  return
              }
        
        hideKeyboard()
        
//        AuthenticationManager.shared.signIn(email: email, password: password) { [weak self] success in
////            switch success {
////            case true:
////                self?.dismiss(animated: true)
////            case false:
////                break
////            }
//        }
        
    }
    
    @objc private func didTapSignUp(){
        hideKeyboard()
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
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
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func configureButtons(){
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    

}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapSignIn()
        }
        
        return true
    }
    
}
