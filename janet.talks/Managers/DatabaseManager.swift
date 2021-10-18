//
//  DatabaseManager.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation
import Firebase

final class DatabaseManager {
    
    //MARK: - properties
    
    static let shared = DatabaseManager()
    
    private let db = Firestore.firestore()
    
    private init(){}
    
    //MARK: - public helpers
    
    public enum DatabaseErrors: Error {
        case usernameTaken
    }
    
    public func createUser(newUser: User, completion: @escaping(Result<Bool,Error>) -> Void){
        
        self.checkIfUsernameIsTaken(newUser.username) { result in
            switch result {
            case .success(_):
                
                let reference = self.db.document("users/\(newUser.username)")
                
                guard let data = newUser.asDictionary() else {
                    completion(.failure(DatabaseErrors.usernameTaken))
                    return
                }
                
                reference.setData(data) { error in
                    completion(.success(error == nil))
                }
            case .failure(let error):
                
                completion(.failure(error))
                
            }
        }
        
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
            }
            
        }
    }
}
