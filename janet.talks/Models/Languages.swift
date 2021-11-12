//
//  Languages.swift
//  janet.talks
//
//  Created by Coding on 11/9/21.
//

import Foundation

enum ChosenLanguage {
    case english
    case spanish
    case chinese
    case french
    
    var description: String {
        switch self {
        case .english:
            return "english"
        case .spanish:
            return "spanish"
        case .chinese:
            return "chinese"
        case .french:
            return "french"
        }
    }
}

