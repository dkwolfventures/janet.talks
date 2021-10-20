//
//  User.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import Foundation

struct User: Codable {
    let username: String
    let email: String
    
    public func usernameIsSafe() -> (Bool, UsernameSafetyError?){
        
        let username = username
        
        var letterCount: Int = 0
        var numberCount: Int = 0
        var dashOrUnderscoreCount: Int = 0
        var illegalCharCount: Int = 0
        
        if username.isEmpty {
            return (false, .isEmpty)
        }
        
        if username.contains(" "){
            return (false, .containsSpace)
        }
        
        if username.contains("."){
            return (false, .containsPeriod)
        }
        
        if username.count > 30 {
            return (false, .tooLong)
        }
        
        if username.first == "-" || username.first == "_" {
            return (false, .startingWithSpecialCharacter)
        }
        
        for char in username {
            
            if char.isLetter {
                letterCount += 1
            } else if char.isNumber {
                numberCount += 1
            } else if "\(char)" == "-" || "\(char)" == "_" {
                dashOrUnderscoreCount += 1
            } else {
                illegalCharCount += 1
            }
            
        }
        
        
            
        return illegalCharCount == 0 ? (true, nil) : (false, .illegalCharacter)
    }
    
}
