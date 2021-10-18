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
    
    public var completion: (() -> Void)?
    
    public var isSignedIn: Bool {
        auth.currentUser != nil
    }
    
    //MARK: - lifecycle
    private init(){}
    
    //MARK: - helpers public
    
    public func signUpWithUsernameAndEmail(authCredentials: AuthCredentials, completion: @escaping(Result<User, Error>) -> Void){
        
        auth.createUser(withEmail: authCredentials.email, password: authCredentials.password) { result, error in
            
            guard error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            let user = User(username: authCredentials.username, email: authCredentials.email)
            
            DatabaseManager.shared.createUser(newUser: user) { result in
                switch result {
                case .success(let user):
                    
                    completion(.success(user))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        }
        
    }
    
    //MARK: - helpers private
    
}
