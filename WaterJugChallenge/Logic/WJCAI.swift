//
//  WJCAI.swift
//  WaterJugChallenge (iOS)
//
//  Created by Carlos Peralta on 12/03/2022.
//

import Foundation

enum WJC_AI_ActionType: UInt {
    case fillContainerA = 0,
         fillContainerB,
         emptyContainerA,
         emptyContainerB,
         transferContainerAToContainerB,
         transferContainerBToContainerA,
         objectiveIsInA,
         objectiveIsInB,
         fillContainer,
         emptyContainer,
         transferContainer
}

class WJCAI{
    
    private var containerASizeInGallons: Int
    private var containerBSizeInGallons: Int
    private var objectiveGallonsInContainerAorB: Int
    
    private var actionsUsingAB = [WJC_AI_ActionType]()
    private var actionsUsingBA = [WJC_AI_ActionType]()
   
    
    init(containerASizeInGallons: Int, containerBSizeInGallons: Int, objectiveGallonsInContainerAorB: Int){
        self.containerASizeInGallons = containerASizeInGallons
        self.containerBSizeInGallons = containerBSizeInGallons
        self.objectiveGallonsInContainerAorB = objectiveGallonsInContainerAorB
    }
    
    func getActionsAsWJCHomeVM()->WJCHomeVM{
        if checkIfIsPossible(a: containerASizeInGallons, b: containerBSizeInGallons, obj: objectiveGallonsInContainerAorB){
            
            let firstAInteractions = transfer(fromContainer: containerASizeInGallons, toContainer: containerBSizeInGallons, obj: objectiveGallonsInContainerAorB, isFirstContainer: true)
            let firstBInteractions = transfer(fromContainer: containerBSizeInGallons, toContainer: containerASizeInGallons, obj: objectiveGallonsInContainerAorB, isFirstContainer: false)
            
            let minInteractions = min(firstAInteractions,firstBInteractions)
            
            let minInteractionAtions = minInteractions == firstAInteractions ? actionsUsingAB : actionsUsingBA
            
       
            return WJCHomeVM(actions: minInteractionAtions, isPossible: true)
        }else{
            return WJCHomeVM(actions: nil, isPossible: false)
        }
    }
    
    
    private func checkIfIsPossible(a: Int, b: Int, obj: Int)->Bool{
        if obj > max(a, b) || obj % gcd(a: a, b: b) != 0{
            return false
        }
        return true
    }
    
    private func gcd(a: Int, b: Int)->Int{
        if b == 0{
            return a
        }
        return gcd(a: b, b: a % b)
    }
    
    private func selectActionsOrder(isFirstContainer: Bool, action: WJC_AI_ActionType){
         if isFirstContainer{
            switch action {
                case .fillContainer:
                    actionsUsingAB.append(.fillContainerA)
                case .emptyContainer:
                    actionsUsingAB.append(.emptyContainerB)
                case .transferContainer:
                    actionsUsingAB.append(.transferContainerAToContainerB)
                default:
                    print("General Action send to selectActionsOrder is uknow")
            }
        }else{
            switch action {
                case .fillContainer:
                    actionsUsingBA.append(.fillContainerB)
                case .emptyContainer:
                    actionsUsingBA.append(.emptyContainerA)
                case .transferContainer:
                    actionsUsingBA.append(.transferContainerBToContainerA)
                default:
                    print("General Action send to selectActionsOrder is uknow")
            }
        }
    }
    
    private func transfer(fromContainer: Int, toContainer: Int, obj: Int, isFirstContainer: Bool)->Int{
        var from = fromContainer
        var to = 0
        var interaction = 1
        
        selectActionsOrder(isFirstContainer: isFirstContainer, action: .fillContainer)
   
        while from != obj && to != obj{
            let temp = min(from, toContainer - to)
            to += temp;
            from -= temp;
            
            selectActionsOrder(isFirstContainer: isFirstContainer, action: .transferContainer)
        
            interaction = interaction + 1
          
            if from == obj || to == obj{
                break
            }
          
            if from == 0{
                from = fromContainer;
                
                selectActionsOrder(isFirstContainer: isFirstContainer, action: .fillContainer)
                
                interaction = interaction + 1
            }
         
            if to == toContainer{
                to = 0;
                interaction = interaction + 1
                
                selectActionsOrder(isFirstContainer: isFirstContainer, action: .emptyContainer)
            }
        }
        
        if from == obj{
            if isFirstContainer{
                actionsUsingAB.append(.objectiveIsInA)
            }else{
                actionsUsingBA.append(.objectiveIsInB)
            }
        }else{
            if isFirstContainer{
                actionsUsingAB.append(.objectiveIsInB)
            }else{
                actionsUsingBA.append(.objectiveIsInB)
            }
        }
        return interaction
    }
}
