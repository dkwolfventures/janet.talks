//
//  PersistenceManager.swift
//  janet.talks
//
//  Created by Coding on 11/8/21.
//

import Foundation

enum Languages: Comparable, Hashable {
    
    case english
    case spanish
    case french
    
    var description: String {
        switch self {
        case .english:
            return "english"
        case .spanish:
            return "spanish"
        case .french:
            return "french"
        }
    }
}

final class PersistenceManager {
    
    ///singleton
    static let shared = PersistenceManager()
    private init(){}
    
    /// Reference to user defaults
    private let userDefaults: UserDefaults = .standard

    /// Constants
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let tagsKey = "tags"
        static let lovedQsKey = "lovedQIDs"
    }

    //MARK: - public
    
    public func setLanguage(language: Languages){
        
        userDefaults.set(language.description, forKey: "language")
        
    }
    
    public lazy var languageChosen = userDefaults.string(forKey: "language")!
    
    public lazy var username = userDefaults.string(forKey: "username")!
    
    public var lovedQustions: [String] {
        return userDefaults.stringArray(forKey: Constants.lovedQsKey) ?? []
    }
    
    public var tags: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setUpDefaultTags()
        }
        
        return userDefaults.stringArray(forKey: Constants.tagsKey) ?? []
    }
    
    public func addQToLovedQs(qID: String) {
        var currentLovedQIDs = lovedQustions
        currentLovedQIDs.append(qID)
        print("DEBUG: loved qids \(currentLovedQIDs). LOVED ID \(qID)")
        userDefaults.set(currentLovedQIDs, forKey: Constants.lovedQsKey)
        userDefaults.set(true, forKey: qID)
    }
    
    public func removeFromLovedQs(qID: String) {
        var currentLovedQIDs = lovedQustions
        currentLovedQIDs.removeAll(where: {$0 == qID})
        print("DEBUG: loved qids \(currentLovedQIDs). REMOVED ID \(qID)")
        userDefaults.set(currentLovedQIDs, forKey: Constants.lovedQsKey)
        userDefaults.removeObject(forKey: qID)
    }
    
    public func hasLovedQ(qID: String) -> Bool{
        
        if lovedQustions.contains(qID){
            let isLoved = userDefaults.bool(forKey: qID)
            
            return isLoved ? true : false
        } else {
            return false
        }
        
    }
    
    public func isFollowingTag(tag: String) -> Bool {
        
        if tags.contains(tag) {
            
            let isFollowing = userDefaults.bool(forKey: tag)
            
            if isFollowing {
                return true
            } else {
                return false
            }
            
        } else {
            return false
        }
        
    }
    
    public func addToFollowedTags(newTag: String){
        var currentlyFollowing = tags
        currentlyFollowing.append(newTag)
        userDefaults.set(currentlyFollowing, forKey: Constants.tagsKey)
        userDefaults.set(true, forKey: newTag)
    }
    
    public func removeFromFollowedTags(tagToRemove: String){
        userDefaults.set(false, forKey: tagToRemove)
    }
    
    
    //MARK: - private
    /// Check if user has been onboarded
    
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: Constants.onboardedKey)
    }
    
    private func setUpDefaultTags(){
        let map: [String: Any] = ["janet": true]
        
        let tags = map.keys.map { $0 }
        userDefaults.set(tags, forKey: Constants.tagsKey)
        
        for (newTag, isFollowing) in map {
            userDefaults.set(isFollowing, forKey: newTag)
        }
    }
}
