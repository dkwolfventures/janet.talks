//
//  UserManager.swift
//  janet.talks
//
//  Created by Coding on 10/19/21.
//

import Foundation
import Firebase

final class UserManager {
    static let shared = UserManager()
    
    private init(){}
    
    //MARK: - public
    
    public func signOut(){
        do{
            
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "username")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func createTempUsername() -> String {
        return (firstNames.randomElement()?.lowercased())! + middlePart.randomElement()! + (lastNames.randomElement()?.lowercased())! + "\(randomNum)"
    }
    
    //MARK: - private
    
    private let firstNames = ["Barbie", "Babe", "ImA", "Sparkely", "Flower", "Keyboard", "Question"]
    private let middlePart = ["-", "_", ""]
    private let lastNames = ["Ninja", "Advice", "Unicorn", "Helper", "Master", "Seeker", "Giver"]
    private let randomNum = Int.random(in: 1000...9999)

}
