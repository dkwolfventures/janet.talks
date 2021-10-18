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
    
    public func signUpWithUsernameAndEmail(email: String, password: String, completion: @escaping(Result<String, Error>) -> Void){
        
        auth.createUser(withEmail: email, password: password) { result, error in
            guard let email = result?.user.email, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
//            DatabaseManager.shared.createUser(newUser: <#T##User#>, completion: <#T##(Result<Bool, Error>) -> Void#>)
            completion(.success(email))
            
        }
        
    }
    
    //MARK: - helpers private
    
}
