//
//  DatabaseManager.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation
import Firebase

enum DatabaseErrors: Error {
    case usernameTaken
    
    var localizedDescription: String {
        return "This username is already taken, please try a different one."
    }
}

final class DatabaseManager {
    
    //MARK: - properties
    
    static let shared = DatabaseManager()
    
    private let db = Firestore.firestore()
    
    private init(){}
    
    //MARK: - public helpers
    
    public func createUser(newUser: User, completion: @escaping(Result<User,Error>) -> Void){
        
        self.checkIfUsernameIsTaken(newUser.username) { result in
            switch result {
            case .success(_):
                
                let reference = self.db.document("users/\(newUser.username)")
                
                guard let data = newUser.asDictionary() else {
                    completion(.failure(DatabaseErrors.usernameTaken))
                    return
                }
                
                reference.setData(data) { error in
                    completion(.success(newUser))
                }
            case .failure(let error):
                
                if error.localizedDescription == DatabaseErrors.usernameTaken.localizedDescription {
                    
                    let usernameTakenReference = self.db.collection("users").document()
                    
                    
                    
                    completion(.failure(error))
                } else {
                    completion(.failure(error))
                }
                
            }
        }
        
    }
    
    public func changeUsernameBecuaseItWasTaken(username: String, completion: @escaping(Result<User, Error>) -> Void){
        
        
        
    }
    
    //MARK: - private helpers
    
    private func checkIfUsernameIsTaken(_ username: String, completion: @escaping(Result<Bool,Error>) -> Void){
        let reference = db.document("users/\(username)")
        
        reference.getDocument { document, error  in
            
            guard let document = document, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            if !document.exists {
                completion(.success(document.exists))
            } else {
                completion(.failure(DatabaseErrors.usernameTaken))
            }
            
        }
    }
    
}
