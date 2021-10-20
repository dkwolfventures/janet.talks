//
//  UsernamePickerViewController.swift
//  janet.talks
//
//  Created by Coding on 10/19/21.
//

import UIKit

enum UsernamePickReasons: String {
    case usernameTaken
    case accountHasNoUsername
}

class UsernamePickerViewController: UIViewController {
    
    //MARK: - properties
    
    public var completion: (() -> Void)?
    
    private let logoView = LogoImageView(frame: .zero)
    
    private let usernameInput = AuthField(.username)
    private let user: User
    private let reason: UsernamePickReasons
    
    private lazy var stack = UIStackView(arrangedSubviews: [usernameInput])
    
    //MARK: - lifecycle
    
    init(reason: UsernamePickReasons, user: User){
        self.user = user
        self.reason = reason
        super.init(nibName: nil, bundle: nil)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Username"
        
        view.backgroundColor = .systemBackground
        view.addSubview(logoView)
        view.addSubview(stack)
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        usernameInput.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if reason == .usernameTaken {
            showAlert(with: user.username, errorMessage: nil)
        } else {
            showAlert(with: nil, errorMessage: nil)
        }
        
        
        let spacing = view.spacing * 2
        let logoSize = CGSize(width: 200, height: 200)
        logoView.frame = CGRect(x: view.width/2 - (logoSize.width/2), y: view.safeAreaInsets.top, width: logoSize.width, height: logoSize.height)
        
        let stackWidth = view.width - (spacing * 2)
        let stackCount = CGFloat(stack.subviews.count)
        let stackSectionHeight: CGFloat = stackCount * 60 + (stackCount - 1 * 12)
        stack.frame = CGRect(x: view.width/2 - (stackWidth / 2), y: logoView.bottom, width: stackWidth, height: stackSectionHeight)
        
        usernameInput.becomeFirstResponder()
    }
    
    //MARK: - actions
    
    @objc private func submitUsernameTapped(){
        guard let username = usernameInput.text else {
            return
        }
        
        view.showLoader(loadingWhat: "Checking Username...")
        
        let tempUser = User(username: username, email: user.email)
        
        if tempUser.usernameIsSafe().0 {
            let newUser = User(username: username, email: user.email)
            
            DatabaseManager.shared.createUser(newUser: newUser) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.view.dismissLoader()
                    UserDefaults.standard.set(user.username, forKey: "username")
                    UserDefaults.standard.set(user.email, forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "doesntHaveUserName")
                    self?.completion?()
                    
                case .failure(let error):
                    
                    if error.localizedDescription == DatabaseErrors.usernameTaken.localizedDescription {
                        DispatchQueue.main.async {
                            self?.usernameInput.text = nil
                            self?.showAlert(with: newUser.username, errorMessage: nil)
                        }
                    }
                    
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(with: nil,
                                errorMessage: tempUser.usernameIsSafe().1?.localizedDescription)
            }
        }
        
    }
    
    //MARK: - helpers
    
    private func showAlert(with name: String?, errorMessage: String?){
        
        var message: String {
            return reason == .usernameTaken ? "It seems like the username \(name!) has been taken. Please enter different one :)" : "It seems as if your account doesn't have a username associated with it! Let's pick one now :)"
        }
        
        var theErrorMessage: String {
            return errorMessage != nil ? errorMessage! : message
        }
        
        let alert = UIAlertController(title: "Uh No!", message: theErrorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak self] _ in
            self?.usernameInput.text = nil
            self?.usernameInput.becomeFirstResponder()
        }))
        
        present(alert, animated: true)
    }
    
    private func configureUI(){
        usernameInput.returnKeyType = .continue
        usernameInput.placeholder = "Username..."
    }

}

//MARK: - UITextFieldDelegate

extension UsernamePickerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameInput {
            submitUsernameTapped()
        }
        
        return true
    }
    
}
