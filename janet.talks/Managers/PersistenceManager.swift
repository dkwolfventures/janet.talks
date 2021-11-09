//
//  PersistenceManager.swift
//  janet.talks
//
//  Created by Coding on 11/8/21.
//

import Foundation

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
    }

    //MARK: - public
    
    public var tags: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setUpDefaultTags()
        }
        
        return userDefaults.stringArray(forKey: Constants.tagsKey) ?? []
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
