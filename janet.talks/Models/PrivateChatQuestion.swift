//
//  PrivateChatQuestion.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation

struct PrivateChatQuestion: Codable {
    let questionID: String
    let featuredImageUrl: URL?
    let subject: String
    let question: String
    let background: String?
    var relationshipExpertId: String?
}
