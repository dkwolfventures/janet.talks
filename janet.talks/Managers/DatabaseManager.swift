//
//  DatabaseManager.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation
import UIKit
import Firebase

enum DatabaseEndpoints: String {
    case globalFeed
    case users
    case publicQuestions
}

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
    
    public func createQuestion(question: PublicQuestionToAdd, qId: String, completion: @escaping(Result<Bool?, Error>) -> Void){
        
        guard let title = question.title, let featuredImage = question.featuredImage, let questionBody = question.question else {
            return
        }
    
        var questionToAdd = TempPublicQuestion(questionID: qId, title: title, featuredImageUrl: "", tags: nil, askedDate: Date().shortDateTime, question: questionBody, background: nil, numOfPhotos: question.questionImages!.count, lovers: [], askerUsername: PersistenceManager.shared.username)
        
        let timestamp  = Timestamp(date: Date()).seconds
        
        //if the user chose a custom featured image

        if question.defaultFeaturedImageName != "" {
            questionToAdd.featuredImageUrl = question.defaultFeaturedImageName!
        } else {
            StorageManager.shared.uploadFeaturedImage(customImage: featuredImage, questionID: qId) { result in
                
                switch result {
                case .success(let url):
                    guard let url = url else {return}
                    questionToAdd.featuredImageUrl = url.absoluteString
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } //exit if statement

        if let tags = question.tags {
            
            if !tags.isEmpty {
                self.saveQIdAndTimestampToTags(tags: tags, qId: qId, timestamp: timestamp)
                questionToAdd.tags = tags
            }
            
        }

        if let background = question.situationOrBackground {
            if background != "" {
                questionToAdd.background = background
            }
        }
        
        if let photos = question.questionImages {
            if !photos.isEmpty {
                StorageManager.shared.uploadQuestionImages(photos: photos, questionId: qId)
            }
        }
        
        if let questionDict = questionToAdd.asDictionary() {
            
            var dictData = questionDict
            
            dictData["timestamp"] = timestamp
            
            self.db.collection(DatabaseEndpoints.globalFeed.rawValue).document(DatabaseEndpoints.publicQuestions.rawValue).collection(PersistenceManager.shared.languageChosen).document(qId).setData(dictData) { error in

                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                self.saveQIdToUserProfile(qId: qId, timestamp: timestamp)
                completion(.success(true))
            }
            
        }
    }
    
    public func uploadURLsToPostedQuestion(qId: String, urls: [String]){
        
        db.collection(DatabaseEndpoints.globalFeed.rawValue).document(DatabaseEndpoints.publicQuestions.rawValue).collection(PersistenceManager.shared.languageChosen).document(qId).setData(["questionPhotosURLs": urls], merge: true)
        
    }
    
    
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
    
    public func getIDForQuestion() -> String{
        
        let reference = db.collection("globalFeed").document("publicQuestions").collection(PersistenceManager.shared.languageChosen).document()
        
        reference.setData([:])
        
        return reference.documentID
        
    }
    
    public func fetchGlobalFeed(completion: @escaping(Result<([PublicQuestion], QueryDocumentSnapshot), Error>) -> Void){
        
        if UserDefaults.standard.string(forKey: "language") != nil {
            
            let reference = db.collection("globalFeed").document("publicQuestions").collection(PersistenceManager.shared.languageChosen).order(by: "timestamp").limit(to: 20)
            
            reference.getDocuments { snapshot, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let questions = snapshot?.documents.compactMap({PublicQuestion(with: $0.data())}), let lastDoc = snapshot?.documents.last else {return}
                
                completion(.success((questions, lastDoc)))
                
            }
            
        } else {
            
            PersistenceManager.shared.setLanguage(language: .english)
            
            let reference = db.collection("globalFeed").document("publicQuestions").collection(PersistenceManager.shared.languageChosen).order(by: "timestamp").limit(to: 20)
            
            reference.getDocuments { snapshot, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let questions = snapshot?.documents.compactMap({PublicQuestion(with: $0.data())}), let lastDoc = snapshot?.documents.last else {return}
                
                completion(.success((questions, lastDoc)))
                
            }
            
        }
        
    }
    
    public func addToGlobalFeed(lastDoc: QueryDocumentSnapshot, completion: @escaping(Result<([PublicQuestion], QueryDocumentSnapshot), Error>) -> Void){
        
        let reference = db.collection("globalFeed").document("publicQuestions").collection(PersistenceManager.shared.languageChosen).order(by: "timestamp").start(afterDocument: lastDoc).limit(to: 20)
        
        reference.getDocuments { snapshot, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let questions = snapshot?.documents.compactMap({PublicQuestion(with: $0.data())}), let lastDoc = snapshot?.documents.last else {return}
            
            completion(.success((questions, lastDoc)))
        }
    }
    
    //MARK: - private helpers
    
    private func saveQIdAndTimestampToTags(tags: [String], qId: String, timestamp: Int64){
        
        for tag in tags {
            db.document("tags/\(PersistenceManager.shared.languageChosen)/\(tag)/\(qId)").setData(["qId" : qId,
                          "timestamp" : timestamp], merge: true)
        }
        
    }
    
    private func saveQIdToUserProfile(qId: String, timestamp: Int64){
        
        db.document("users/\(PersistenceManager.shared.username)/ownedPublicQs/\(qId)").setData(["qId" : qId,
                                                             "timestamp" : Timestamp(date: Date()),
                                                             "language" : PersistenceManager.shared.languageChosen], merge: true)
    }
    
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
