//
//  PublicQuestion.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation

struct PublicQuestion: Codable, Hashable {
    
    let questionID: String
    let title: String
    let featuredImageUrl: String
    let tags: [String]?
    let askedDate: String
    let question: String
    let background: String?
    let numOfPhotos: Int
    let questionPhotoURLs: [String]?
    let lovers: [String]
    let askerUsername: String
    
    var date: Date {
        guard let date = DateFormatter.formatter.date(from: askedDate) else { fatalError() }
        return date
    }
    
    var storageReferences: [String] {
        let username = PersistenceManager.shared.username
        var results = [String]()
        
        if numOfPhotos > 0 {
            
            for idx in 0..<numOfPhotos {
                results.append("\(username)/public-q-photos/\(questionID)\(idx)")
            }
            
        }
        return results
    }

}

struct TempPublicQuestion: Codable, Hashable {
    
    var questionID: String
    var title: String
    var featuredImageUrl: String
    var tags: [String]?
    var askedDate: String
    var question: String
    var background: String?
    var numOfPhotos: Int
    var lovers: [String]
    var askerUsername: String
    
    var date: Date {
        guard let date = DateFormatter.formatter.date(from: askedDate) else { fatalError() }
        return date
    }

}
