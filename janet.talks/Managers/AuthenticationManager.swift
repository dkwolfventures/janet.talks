//
//  AuthenticationManager.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation
import Firebase

final class AuthenticationManager {
    
    //MARK: - properties
    
    static let shared = AuthenticationManager()
    
    private let auth = Auth.auth()
    
    public var isSignedIn: Bool {
        auth.currentUser != nil
    }
    
    //MARK: - lifecycle
    private init(){}
    
    //MARK: - helpers public
    
    //MARK: - helpers private
    
}
