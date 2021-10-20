//
//  DatabaseManager.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation
import Firebase

enum DatabaseErrors: Comparable, Equatable, Error {
    case usernameTaken
    case databaseError
    case accountNoUsername
    
    var localizedDescription: String {
        switch self {
        case .usernameTaken:
            return "This username is already taken, please try a different one."

        case .databaseError:
            return "There was a network error, please try again!"
            
        case .accountNoUsername:
            return "This account has no username."
        }
    }
}

final class DatabaseManager {
    
    //MARK: - properties
    
    static let shared = DatabaseManager()
    
    private let db = Firestore.firestore()
    
    private init(){}
    
    //MARK: - public helpers
    
    public func createUser(newUser: User, completion: @escaping(Result<User,Error>) -> Void){
        
        self.checkIfUsernameIsTaken(newUser.username) { [weak self] result in
            switch result {
            case .success(_):
                
                let reference = self?.db.document("users/\(newUser.username)")
                
                guard let data = newUser.asDictionary() else {
                    completion(.failure(DatabaseErrors.databaseError))
                    return
                }
                
                reference?.setData(data) { error in
                    completion(.success(newUser))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    public func findUser(email: String, completion: @escaping(Result<User, Error>) -> Void){
        
        let ref = db.collection("users").whereField("email", isEqualTo: email)
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let users = snapshot?.documents.compactMap({User(with: $0.data())}) else {
                completion(.failure(DatabaseErrors.accountNoUsername))
                return
            }
            
            if !users.isEmpty {
                completion(.success(users[0]))
            } else {
                completion(.failure(DatabaseErrors.accountNoUsername))
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
            } else {
                completion(.failure(DatabaseErrors.usernameTaken))
            }
            
        }
    }
    
}
