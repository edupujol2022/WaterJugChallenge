//
//  WJCHomeVC.swift
//  WaterJugChallenge
//
//  Created by Carlos Peralta on 14/03/2022.
//

import Foundation
import UIKit

class WJCHomeVC: UIViewController{
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var jug1View: UIView!
    @IBOutlet weak var jug1Height: NSLayoutConstraint!
    @IBOutlet weak var jug2Height: NSLayoutConstraint!
    @IBOutlet weak var waterJug1Height: NSLayoutConstraint!
    @IBOutlet weak var waterJug2Height: NSLayoutConstraint!
    @IBOutlet weak var callAIButton: UIButton!
    @IBOutlet weak var stepInfoLabel: UILabel!
    @IBOutlet weak var jug1SizeLabel: UILabel!
    @IBOutlet weak var objectiveLabel: UILabel!
    @IBOutlet weak var jug2SizeLabel: UILabel!
  
    private var ai: WJCAI!
    internal var vm: WJCHomeVM!
    private var stepGlobalIndex: Int!
    private var originalBottomJug1: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        waterJug1Height.constant = 0
        waterJug2Height.constant = 0
        
        stepGlobalIndex = 0
        
        jug1SizeLabel.text = NSLocalizedString("JUG1_SIZE", comment: "Jug1 Size")
        jug2SizeLabel.text = NSLocalizedString("JUG2_SIZE", comment: "Jug2 Size")
        objectiveLabel.text = NSLocalizedString("OBJECTIVE", comment: "Objective")
        callAIButton.setTitle(NSLocalizedString("LETS_CALL_AI", comment: "Let me see how you do it AI!"), for: .normal)
    }
    
    internal func updateJugViews(){
        let valueJug1Row = self.picker.selectedRow(inComponent: 0) + 1
        let valueJug2Row = self.picker.selectedRow(inComponent: 1) + 1
        
        if valueJug1Row == max(valueJug1Row, valueJug2Row){
            jug1Height.constant = 310
            jug2Height.constant = CGFloat((310 * valueJug2Row) / valueJug1Row)
        }else{
            jug2Height.constant = 310
            jug1Height.constant = CGFloat((310 * valueJug1Row) / valueJug2Row)
        }
        executeAnimationOnLayoutIfNeeded()
    }
    
    @IBAction func callAI(_ sender: Any) {
        callAIExecute()
    }
    
    internal func callAIExecute(){
        ai = WJCAI(containerASizeInGallons: picker.selectedRow(inComponent: 0) + 1, containerBSizeInGallons: picker.selectedRow(inComponent: 1) + 1, objectiveGallonsInContainerAorB: picker.selectedRow(inComponent: 2) + 1)
        
        vm = ai.getActionsAsWJCHomeVM()
        
        if !vm.isPossible{
            let alert = UIAlertController(title: "Is not possible", message: "Is not possible with those sizes and objective. Please select others values", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            callAIButton.isEnabled = false
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                self.callAIButton.alpha = 0
                self.picker.alpha = 0.3
                self.picker.isUserInteractionEnabled = false
            }, completion: { [weak self]  finished in
                guard let self = self else { return }
                self.goForStep(stepIndex: 0)
            })
        }
    }
    
    private func goForStep(stepIndex: Int){
        stepInfoLabel.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {  [weak self] in
            guard let self = self else { return }
            if let actions = self.vm.actions{
                let action = actions[stepIndex]
                self.stepInfoLabel.text = self.getTextInfoFromAction(action: action)
                self.stepInfoLabel.alpha = 1
                self.proccessActionInJugs(action: action)
            }
        }, completion: { finished in
             UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                self.stepInfoLabel.alpha = 0
            }, completion: { [weak self] finished in
                guard let self = self else { return }
                self.stepGlobalIndex = self.stepGlobalIndex + 1
                if let actions = self.vm.actions, self.stepGlobalIndex < actions.count{
                    self.goForStep(stepIndex: self.stepGlobalIndex)
                }else{
                    self.callAIButton.isEnabled = true
                    self.callAIButton.alpha = 1
                    self.picker.alpha = 1
                    self.stepGlobalIndex = 0
                    self.waterJug1Height.constant = 0
                    self.waterJug2Height.constant = 0
                    self.picker.selectRow(0, inComponent: 0, animated: true)
                    self.picker.selectRow(0, inComponent: 1, animated: true)
                    self.picker.selectRow(0, inComponent: 2, animated: true)
                    self.updateJugViews()
                    self.picker.isUserInteractionEnabled = true
                }
            })
        })
    }
    
    private func executeAnimationOnLayoutIfNeeded(){
        UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    internal func proccessActionInJugs(action: WJC_AI_ActionType){
        switch action {
            case .fillContainerA:
                waterJug1Height.constant = jug1Height.constant
                executeAnimationOnLayoutIfNeeded()
            case .fillContainerB:
                waterJug2Height.constant = jug2Height.constant
                executeAnimationOnLayoutIfNeeded()
            case .emptyContainerA:
                waterJug1Height.constant = 0
                executeAnimationOnLayoutIfNeeded()
            case .emptyContainerB:
                waterJug2Height.constant = 0
                executeAnimationOnLayoutIfNeeded()
            case .transferContainerAToContainerB:
                let restInB = jug2Height.constant - waterJug2Height.constant
            
                if waterJug1Height.constant > restInB{
                    waterJug2Height.constant = jug2Height.constant
                    waterJug1Height.constant = waterJug1Height.constant - restInB
                }else{
                    waterJug2Height.constant = waterJug2Height.constant + waterJug1Height.constant
                    waterJug1Height.constant = 0
                }
                executeAnimationOnLayoutIfNeeded()
            case .transferContainerBToContainerA:
                let restInA = jug1Height.constant - waterJug1Height.constant
                
                if waterJug2Height.constant > restInA{
                    waterJug1Height.constant = jug1Height.constant
                    waterJug2Height.constant = waterJug2Height.constant - restInA
                }else{
                    waterJug1Height.constant = waterJug1Height.constant + waterJug2Height.constant
                    waterJug2Height.constant = 0
                }
                executeAnimationOnLayoutIfNeeded()
            default:
                print("WJC_AI_ActionType action is unknow")
        }
    }
    
    private func getTextInfoFromAction(action: WJC_AI_ActionType)->String{
        switch action {
            case .fillContainerA:
                return NSLocalizedString("JUG1_FILL_ACTION_INFO", comment: "Fill Jug1")
            case .fillContainerB:
                return NSLocalizedString("JUG2_FILL_ACTION_INFO", comment: "Fill Jug2")
            case .emptyContainerA:
                return NSLocalizedString("JUG1_EMPTY_ACTION_INFO", comment: "Empty Jug1")
            case .emptyContainerB:
                return NSLocalizedString("JUG2_EMPTY_ACTION_INFO", comment: "Empty Jug2")
            case .transferContainerAToContainerB:
                return NSLocalizedString("JUG1_TO_JUG2_TRANSFER_ACTION_INFO", comment: "(Transfer Jug1 to Jug2) >>>>>> ")
            case .transferContainerBToContainerA:
                return NSLocalizedString("JUG2_TO_JUG1_TRANSFER_ACTION_INFO", comment: "<<<<<< (Transfer Jug2 to Jug1)")
            case .objectiveIsInA:
                return NSLocalizedString("JUG1_OBJECTIVE_ACTION_INFO", comment: "Objective is in Jug1!")
            case .objectiveIsInB:
                return NSLocalizedString("JUG2_OBJECTIVE_ACTION_INFO", comment: "Objective is in Jug2!")
            default:
                return ""
        }
    }
}

// MARK: - extension: UIPickerViewDataSource
extension WJCHomeVC: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 15
    }
}
    
// MARK: -  extension: UIPickerViewDelegate
extension WJCHomeVC: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.updateJugViews()
    }
}
