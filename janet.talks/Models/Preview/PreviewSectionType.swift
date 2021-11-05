//
//  PreviewSectionType.swift
//  janet.talks
//
//  Created by Coding on 11/1/21.
//

import Foundation

enum PreviewSectionType: CaseIterable {
    case title
    case tags
    case meta
    case question
    case background
    case photos
    case userInfo
    
    var count: Int {
        return 7
    }
}
