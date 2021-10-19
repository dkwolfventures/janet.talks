//
//  UserManager.swift
//  janet.talks
//
//  Created by Coding on 10/19/21.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    
    private init(){}
    
    //MARK: - public
    
    public func createTempUsername() -> String {
        return firstNames.randomElement()! + middlePart.randomElement()! + lastNames.randomElement()!
    }
    
    //MARK: - private
    
    private let firstNames = ["Barbie", "Babe", "ImA", "Sparkely", "Flower", "Keyboard", "Question"]
    private let middlePart = ["-", "_", ""]
    private let lastNames = ["Ninja", "Advice", "Unicorn", "Helper", "Master", "Seeker", "Giver"]
    private let randomNum = Int.random(in: 1000...9999)

}
