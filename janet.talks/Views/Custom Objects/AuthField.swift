//
//  AuthField.swift
//  SOAR
//
//  Created by Coding on 9/28/21.
//

import UIKit

class AuthField: UITextField {

    enum FieldType {
        case email
        case password
        case username
        
        var title: String {
            switch self {
            case .email: return "Email Address"
            case .password: return "Password"
            case .username: return "Username"
            }
        }
    }
    
    private var type: FieldType
    
    init(_ type: FieldType){
        self.type = type
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        if type == .password {
            textContentType = .oneTimeCode
            isSecureTextEntry = true
            returnKeyType = .done
        } else if type == .email {
            textContentType = .emailAddress
            returnKeyType = .next
            keyboardType = .emailAddress
        } else {
            
            keyboardType = .alphabet
            returnKeyType = .next
        }
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        autocorrectionType = .no
        autocapitalizationType = .none
        
    }
}
