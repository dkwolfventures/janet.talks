//
//  AuthButton.swift
//  SOAR
//
//  Created by Coding on 9/28/21.
//

import UIKit

class AuthButton: UIButton {

    enum ButtonType {
        case signIn
        case signUp
        case plain
        
        var title: String {
            switch self {
            case .signIn:
                return "Sign In"
            case .signUp:
                return "Sign Up"
            case .plain:
                return "Button"
            }
        }
    }
    
    private let type: ButtonType
    private var title: String? = nil
    
    init(_ type: ButtonType, title: String? = nil){
        self.type = type
        self.title = title
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 8
        layer.masksToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.sizeToFit()
        titleLabel?.font = .systemFont(ofSize: 19, weight: .heavy)
        
        if type != .plain {
            setTitle(type.title, for: .normal)
        } else {
            setTitle(title, for: .normal)
        }
        
        switch type {
        case .signIn:
            backgroundColor = .systemBlue
        case .signUp:
            backgroundColor = .systemGreen
        case .plain:
            titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            setTitleColor(.link, for: .normal)
            backgroundColor = .clear
        }
        
    }
}
