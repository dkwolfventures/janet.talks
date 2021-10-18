//
//  SignUpViewController.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import UIKit
import ProgressHUD

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
        ProgressHUD.show("Creating User...")
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        let authCreds = AuthCredentials(username: username, email: email, password: password)
        
        if authCreds.usernameIsSafe().0 && authCreds.isValidEmail().0 && authCreds.passwordIsSafe().0 {
            
            AuthenticationManager.shared.signUpWithUsernameAndEmail(authCredentials: authCreds) { [weak self] result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success( let user):
                        ProgressHUD.dismiss()
                        UserDefaults.standard.setValue(user.email, forKey: "email")
                        UserDefaults.standard.setValue(user.username, forKey: "username")
                        
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.completion?()
                        
                    case .failure(let error):
                        ProgressHUD.dismiss()
                        
                        if error.localizedDescription == DatabaseErrors.usernameTaken.localizedDescription {
                            
                        } else {
                            let alert = UIAlertController(title: "Ooops", message: error.localizedDescription, preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            
                            self?.present(alert, animated: true)
                            
                        }
                        
                    }
                }
                
            }
            
        } else {
            ProgressHUD.dismiss()
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
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
