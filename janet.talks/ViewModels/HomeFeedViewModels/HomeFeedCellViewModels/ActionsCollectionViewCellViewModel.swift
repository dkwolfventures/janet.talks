//
//  ActionsCollectionViewCellViewModel.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import Foundation

struct ActionsCollectionViewCellViewModel {
    let qID: String
    let profileImageUrl: String
    let isLoved: Bool
    let username: String
    let qsAsked: Int
    let postLovers: [String]
    let comments: Int
    let shares: Int
    
    var lovers: Int {
        return postLovers.count
    }
    
    var saveQid: Bool {
        let lovedIDs = PersistenceManager.shared.lovedQustions
        
        return lovedIDs.contains(qID)
    }
}
