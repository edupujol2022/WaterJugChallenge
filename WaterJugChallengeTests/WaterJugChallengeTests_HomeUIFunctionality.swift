//
//  WaterJugChallengeTests_HomeUIFunctionality.swift
//  WaterJugChallengeTests
//
//  Created by Carlos Peralta on 14/03/2022.
//

import XCTest
@testable import WaterJugChallenge


class WaterJugChallengeTests_HomeUIFunctionality: XCTestCase {
    
    var vc: WJCHomeVC!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "WJCHomeVC", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "WJCHomeVC") as? WJCHomeVC{
            self.vc = vc
            vc.loadViewIfNeeded()
        }
    }
   
    func testVisualJugSizeActionFillContainerA(){
        vc.proccessActionInJugs(action: .fillContainerA)
        XCTAssertEqual(vc.waterJug1Height.constant, vc.jug1Height.constant)
    }
    
    func testVisualJugSizeActionFillContainerB(){
        vc.proccessActionInJugs(action: .fillContainerB)
        XCTAssertEqual(vc.waterJug2Height.constant, vc.jug2Height.constant)
    }
    
    func testVisualJugSizeActionEmptyB(){
        vc.proccessActionInJugs(action: .fillContainerB)
        vc.proccessActionInJugs(action: .emptyContainerB)
        XCTAssertEqual(vc.waterJug2Height.constant, 0)
    }
    
    func testVisualJugSizeActionEmptyA(){
        vc.proccessActionInJugs(action: .fillContainerA)
        vc.proccessActionInJugs(action: .emptyContainerA)
        XCTAssertEqual(vc.waterJug1Height.constant, 0)
    }
    
    func testVisualJugSizeActionTransferBtoA(){
        vc.proccessActionInJugs(action: .emptyContainerA)
        vc.proccessActionInJugs(action: .emptyContainerB)
        vc.proccessActionInJugs(action: .fillContainerB)
        XCTAssertEqual(vc.waterJug2Height.constant, vc.jug2Height.constant)
        vc.proccessActionInJugs(action: .transferContainerBToContainerA)
        XCTAssertEqual(vc.waterJug1Height.constant, vc.jug1Height.constant)
    }
    
    func testVisualJugSizeActionTransferAtoB(){
        vc.proccessActionInJugs(action: .emptyContainerA)
        vc.proccessActionInJugs(action: .emptyContainerB)
        vc.proccessActionInJugs(action: .fillContainerA)
        XCTAssertEqual(vc.waterJug1Height.constant, vc.jug1Height.constant)
        vc.proccessActionInJugs(action: .transferContainerAToContainerB)
        XCTAssertEqual(vc.waterJug2Height.constant, vc.jug2Height.constant)
    }
    
    func testPickerAndJugSizes(){
        vc.picker.selectRow(1, inComponent: 1, animated: false)
        vc.updateJugViews()
        sleep(4)
        XCTAssertEqual(self.vc.jug1Height.constant*2, self.vc.jug2Height.constant)
    }
    
    func testCallAIButtonFromPicker2_10_4(){
        vc.picker.selectRow(1, inComponent: 0, animated: false)
        vc.picker.selectRow(9, inComponent: 1, animated: false)
        vc.picker.selectRow(3, inComponent: 2, animated: false)
        sleep(4)
        vc.callAIExecute()
        XCTAssertEqual(vc.vm.actions?.count, 5)
    }
}
