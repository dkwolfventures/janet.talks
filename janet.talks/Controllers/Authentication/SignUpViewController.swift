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
    
    private let logoView = LogoImageView(frame: .zero)
    
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
        
        let spacing = view.spacing * 2
        let logoSize = CGSize(width: 200, height: 200)
        logoView.frame = CGRect(x: view.width/2 - (logoSize.width/2), y: view.safeAreaInsets.top, width: logoSize.width, height: logoSize.height)
        
        let stackWidth = view.width - (spacing * 2)
        let stackCount = CGFloat(stack.subviews.count)
        let stackSectionHeight: CGFloat = stackCount * 60 + (stackCount - 1 * 12)
        stack.frame = CGRect(x: view.width/2 - (stackWidth / 2), y: logoView.bottom, width: stackWidth, height: stackSectionHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameTextField.becomeFirstResponder()
    }
    
    //MARK: - actions
    
    @objc private func didTapSignUp(){
        hideKeyboard()
        view.showLoader(loadingWhat: "Creating User...")
        guard let username = usernameTextField.text?.lowercased(), let email = emailTextField.text?.lowercased(), let password = passwordTextField.text else {
            return
        }
        
        let authCreds = AuthCredentials(username: username, email: email, password: password)
        let user = User(username: username, email: email)
        
        if authCreds.usernameIsSafe().0 && authCreds.isValidEmail().0 && authCreds.passwordIsSafe().0 {
            
            AuthenticationManager.shared.signUpWithUsernameAndEmail(authCredentials: authCreds) { [weak self] result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success( let user):
                        self?.view.dismissLoader()
                        UserDefaults.standard.setValue(user.email, forKey: "email")
                        UserDefaults.standard.setValue(user.username, forKey: "username")
                        
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.completion?()
                        
                    case .failure(let error):
                        self?.view.dismissLoader()
                        
                        switch error {
                        case is DatabaseErrors:
                            DispatchQueue.main.async {
                                UserDefaults.standard.setValue(user.email, forKey: "email")
                                UserDefaults.standard.setValue(true, forKey: "doesntHaveUserName")
                                let vc = UsernamePickerViewController(reason: .usernameTaken, user: user)
                                vc.title = "Username"
                                vc.completion = { [weak self] in
                                    DispatchQueue.main.async {
                                        self?.navigationController?.popToRootViewController(animated: true)
                                        self?.completion?()
                                    }
                                }
                                self?.show(vc, sender: self)
                            }
                        default:
                            let alert = UIAlertController(title: "Ooops", message: error.localizedDescription, preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            
                            self?.present(alert, animated: true)
                            
                        }
                        
                    }
                }
                
            }
            
        } else {
            view.dismissLoader()
            if !authCreds.usernameIsSafe().0 {
                if let error = authCreds.usernameIsSafe().1 {
                    self.showAlert(error, nil, nil)
                }
            } else if !authCreds.isValidEmail().0 {
                if let error = authCreds.isValidEmail().1 {
                    self.showAlert(nil, error, nil)
                }
            } else if !authCreds.passwordIsSafe().0 {
                if let error = authCreds.passwordIsSafe().1 {
                    self.showAlert(nil, nil, error)
                }
            }
            
        }
        
    }
    
    @objc private func didTapForgotPassword(){
        hideKeyboard()
        
    }
    
    //MARK: - helpers
    
    private func showAlert(_ usernameError: UsernameSafetyError?,_ emailError: EmailSafetyError?,_ passwordError: PasswordStrengthError?){
        
        if let usernameError = usernameError {
            
            let alert = UIAlertController(title: "Ooops", message: usernameError.description, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            present(alert, animated: true)
            
        }
        
        if let emailError = emailError {
            
            let alert = UIAlertController(title: "Ooops", message: emailError.description, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            present(alert, animated: true)
            
        }
        
        if let passwordError = passwordError {
            
            let alert = UIAlertController(title: "Ooops", message: passwordError.description, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            present(alert, animated: true)
            
        }
        
    }
    
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
            didTapSignUp()
        }
        
        return true
    }
    
}
