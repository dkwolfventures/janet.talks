//
//  HomeFeedType.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation

enum HomeFeedType: CaseIterable {
    case publicQuestion
    case privateChat
    
    var description: String {
        switch self {
        case .publicQuestion:
            return "public question"
        case .privateChat:
            return "private chat"
        }
    }
}
