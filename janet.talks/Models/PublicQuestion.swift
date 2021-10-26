//
//  PublicQuestion.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation

struct PublicQuestion: Codable, Hashable {
    
    let questionID: String
    let username: String
    let featuredImageUrl: URL?
    let subject: String
    let background: String?
    let question: String
    var lovers: [String]
    let dateAsked: String
    let dateAskedInSecondsSince1970: Int
    let tags: [String]
    
}
