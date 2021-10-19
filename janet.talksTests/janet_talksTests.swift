//
//  janet_talksTests.swift
//  janet.talksTests
//
//  Created by Coding on 10/17/21.
//

import XCTest
import Firebase

@testable import janet_talks

class janet_talksTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserModel_canCreate(){
        let user = User(username: "kanyeWest", email: "kwest@kaysvest.com")

        XCTAssertNotNil(user)
    }
    
    func testCreatesRandomUsername(){
        
        func createTempUsername() -> String {
            return firstNames.randomElement()! + middlePart.randomElement()! + lastNames.randomElement()! + "\(randomNum)"
        }
        
        //MARK: - private
        
        let firstNames = ["Barbie", "Babe", "ImA", "Sparkely", "Flower", "Keyboard", "Question"]
        let middlePart = ["-", "_", ""]
        let lastNames = ["Ninja", "Advice", "Unicorn", "Helper", "Master", "Seeker", "Giver"]
        let randomNum = Int.random(in: 1000...9999)

        let tempUsername = createTempUsername()
        
        XCTAssertNotNil(tempUsername)
        
    }

}
