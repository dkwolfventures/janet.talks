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
    
    private let logoView = LogoImageView(frame: .zero)
    
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
        
        let spacing = view.spacing * 2
        let logoSize = CGSize(width: 200, height: 200)
        logoView.frame = CGRect(x: view.width/2 - (logoSize.width/2), y: view.safeAreaInsets.top, width: logoSize.width, height: logoSize.height)
        
        let stackWidth = view.width - (spacing * 2)
        let stackCount = CGFloat(stack.subviews.count)
        let stackSectionHeight: CGFloat = stackCount * 60 + (stackCount - 1 * 12)
        stack.frame = CGRect(x: view.width/2 - (stackWidth / 2), y: logoView.bottom, width: stackWidth, height: stackSectionHeight)
    }
    
    //MARK: - actions
    
    @objc private func didTapSignIn(){
        
        view.showLoader(loadingWhat: "Signing In...")
        
        hideKeyboard()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        AuthenticationManager.shared.signInUser(email: email, password: password) { [weak self] result in
            
            self?.view.dismissLoader()
            
            switch result {
            case .success(_):
                self?.signedIn()
                
            case .failure(let error):
                
                if let theError = error as? DatabaseErrors {
                    if theError == DatabaseErrors.accountNoUsername {
                        let vc = UsernamePickerViewController(reason: .accountHasNoUsername, user: User(username: "", email: email))
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            vc.modalPresentationStyle = .fullScreen
                            self?.present(vc, animated: true)
                            vc.completion = {
                                vc.dismiss(animated: true) {
                                    self?.signedIn()
                                }
                            }
                        }
                        
                    }
                } else {
                    self?.showAlert(error)
                    UserManager.shared.signOut()
                }
            }
        }
        
    }
    
    @objc private func didTapSignUp(){
        hideKeyboard()
        let vc = SignUpViewController()
        vc.title = "Create Account"
        vc.completion = { [weak self] in
            DispatchQueue.main.async {
                self?.signedIn()
            }
        }
        show(vc, sender: self)
    }
    
    @objc private func didTapForgotPassword(){
        hideKeyboard()
        
    }
    
    //MARK: - helpers
    
    private func showAlert(_ error: Error){
        
        let alert = UIAlertController(title: "Uh Oh!", message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        present(alert, animated: true)
        
    }
    
    private func signedIn(){
        let tabVc = TabBarController()
        tabVc.modalPresentationStyle = .fullScreen
        present(tabVc, animated: true)
    }
    
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
