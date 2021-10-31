//
//  Tags.swift
//  janet.talks
//
//  Created by Coding on 10/30/21.
//

import Foundation

enum TagError: Error {
    case noHashtag
    case duplicate
    case invalidCharacter
    
    var localizedDescription: String {
        switch self {
        case .noHashtag:
            return "No hastag"
        case .duplicate:
            return "Duplicate Tag"
        case .invalidCharacter:
            return "Invalid Char"
        }
    }
}

struct Tags: Codable, Hashable {
    var tags: [String]
    var validTags: [ValidTag]
    
    private func tagIsValid(tag: String) -> (Bool, ValidTag?, TagError?) {
        
        for (idx, char) in tag.enumerated() {
            
            if !char.isLetter || !char.isNumber {
                return (false, nil, .invalidCharacter)
            }
            
            if idx == 0 && char != "#" {
                return (false, nil, .noHashtag)
            }
            
        }
        
        let validTag = ValidTag(tag: tag)
        
        if validTags.contains(validTag) {
            return (false, nil, .duplicate)
        }
        
        return (true, validTag, nil)
        
    }
    
    mutating public func validateTags() {
        
        for tag in tags {
            if tagIsValid(tag: tag).0, let validTag = tagIsValid(tag: tag).1 {
                validTags.append(validTag)
            } else if let error = tagIsValid(tag: tag).2 {
                print(error.localizedDescription)
            }
        }
        
    }
    
}

struct ValidTag: Codable, Hashable {
    var tag: String
}
