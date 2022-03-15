//
//  WaterJugChallengeTests_AI.swift
//  WaterJugChallengeTests
//
//  Created by Carlos Peralta on 15/03/2022.
//

import Foundation

import XCTest
@testable import WaterJugChallenge

class WaterJugChallengeTests_AI: XCTestCase {
 
    func testWJCAIRightNumberOfSteps1of5(){
        // Note: The last action is showing in which Jug is the objective; just information action
        
        let ai = WJCAI(containerASizeInGallons: 2, containerBSizeInGallons: 10, objectiveGallonsInContainerAorB: 4)
        let count = ai.getActionsAsWJCHomeVM().actions?.count
        
        XCTAssertEqual(count, 5)
    }
    
    func testWJCAIRightNumberOfSteps2of5(){
        let ai = WJCAI(containerASizeInGallons: 6, containerBSizeInGallons: 10, objectiveGallonsInContainerAorB: 4)
        let count = ai.getActionsAsWJCHomeVM().actions?.count
        
        XCTAssertEqual(count, 3)
    }
    
    func testWJCAIRightNumberOfSteps3of5(){
        let ai = WJCAI(containerASizeInGallons: 10, containerBSizeInGallons: 6, objectiveGallonsInContainerAorB: 4)
        let count = ai.getActionsAsWJCHomeVM().actions?.count
        
        XCTAssertEqual(count, 3)
    }
    
    func testWJCAIRightNumberOfSteps4of5(){
        let ai = WJCAI(containerASizeInGallons: 3, containerBSizeInGallons: 10, objectiveGallonsInContainerAorB: 4)
        let count = ai.getActionsAsWJCHomeVM().actions?.count
        
        XCTAssertEqual(count, 5)
    }
    
    func testWJCAIRightNumberOfSteps5of5(){
        let ai = WJCAI(containerASizeInGallons: 20, containerBSizeInGallons: 12, objectiveGallonsInContainerAorB: 16)
        let count = ai.getActionsAsWJCHomeVM().actions?.count
        
        XCTAssertEqual(count, 7)
    }
    
    func testWJCAIImpossible(){
        let ai = WJCAI(containerASizeInGallons: 3, containerBSizeInGallons: 5, objectiveGallonsInContainerAorB: 7)
        XCTAssertTrue(!(ai.getActionsAsWJCHomeVM().isPossible))
    }
    
}

