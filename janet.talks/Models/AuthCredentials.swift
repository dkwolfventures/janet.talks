//
//  AuthCredentials.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import Foundation

enum PasswordStrengthError: Error {
    case notEnoughCharacters
    case blankPassword
    case noCapitalLetters
    case noSpecialCharacters
    case tooManyCharacters
    case invalidSpecialCharacter
    case notEnoughNumbers
    case noLowercaseLetters
    case noUppercaseLetters

    var description: String {
        switch self {
        case .notEnoughCharacters:
            return "Please make sure the password you enter is between 6-20 characters in length."
        case .blankPassword:
            return "Your password cannot be made up of blank spaces. This isn't a Taylor Swift song!"
        case .noCapitalLetters:
            return "Your password doesn't contain any capital letters. Please include atleast one!"
        case .noSpecialCharacters:
            return "No special characters were present in your password. Please include one of the following: !@#$%*&-+"
        case .tooManyCharacters:
            return "Please make sure the password you enter is between 6-20 characters in length."
        case .invalidSpecialCharacter:
            return "The password you entered contains special characters that are not allowed! The list of approved special characters include: !@#$%*&-+"
            
        case .notEnoughNumbers:
            return "The password you entered does not have enought numbers in it. Please include at lease one number."
            
        case .noLowercaseLetters:
            return "The password you entered doesn't contain any lowercased letters. Please include at least one."
            
        case .noUppercaseLetters:
            return "The password you entered doesn't contain any capital letters. Please include at least one."
        }
    }
}

enum UsernameSafetyError: Error {
    case containsPeriod
    case containsSpace
    case invalidCharacter
    
    var description: String {
        switch self {
        case .containsPeriod:
            return "Username cannot contain a period. Try a dash or an underscore!"
        case .containsSpace:
            return "Usernames may not contain spaces."
        case .invalidCharacter:
            return "It seems like you have a spcial character that isn't allowed in usernames. Please only use letters from the alphabet, numbers, dashes and underscores."
        }
    }
}

struct AuthCredentials {
    let username: String
    let email: String
    let password: String
    
    public func usernameIsSafe() -> (Bool, UsernameSafetyError?){
        
        let username = username
        
        if username.contains(" "){
            return (false, .containsSpace)
        }
        
        for char in username {
            
            if !char.isNumber || !char.isLetter || "\(char)" == "-" || "\(char)" == "_"{
                return (false, .invalidCharacter)
            }
            
        }
            
            return (true, nil)
    }
    
    public func passwordIsSafe() -> (Bool, PasswordStrengthError?){
        
        let password = password.trimmingCharacters(in: .whitespaces)
        
        var numCount: Int = 0
        var lowcaseCount: Int = 0
        var uppercaseCount: Int = 0
        var specialCharCount: Int = 0
        
        if password.isEmpty {
            return (false, .blankPassword)
        }
        
        if password.count < 6 {
            return (false, .notEnoughCharacters)
        }
        
        if password.count > 20 {
            return (false, .tooManyCharacters)
        }
        
        for char in password {
            if char.isLetter || char.isNumber || approvedSpecialChars.contains("\(char)") {
                if char.isLetter {
                    if char.isLowercase {
                        lowcaseCount += 1
                    } else if char.isUppercase {
                        uppercaseCount += 1
                    }
                }
                
                if char.isNumber {
                    numCount += 1
                }
                
                if approvedSpecialChars.contains("\(char)"){
                    specialCharCount += 1
                }
            }
        }
        
        if numCount == 0 {
            return (false, .notEnoughNumbers)
        }
        
        if lowcaseCount == 0 {
            return (false, .noLowercaseLetters)
        }
        
        if uppercaseCount == 0 {
            return (false, .noUppercaseLetters)
        }
        
        if specialCharCount == 0 {
            return (false, .noSpecialCharacters)
        }
        
        return (true, nil)
        
    }
    
    private let approvedSpecialChars = ["!","@","#","$","%","*","&","-","+" ]
}
