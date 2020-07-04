//
//  ViewController.swift
//  calculator
//
//  Created by M sreekanth  on 07/07/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit

public enum Action: Int {
    
    case Addition = 20
    case Subtraction = 21
    case Multiply = 22
    case Division = 23
    
}

public enum Turn{
    case First
    case Second
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var label: UILabel!
    var operation:Action?
    
    var mathId:Int?
    var firstValue:String?
    var secondValue:String?
    var result:String?
    var text:String = "0"
    
    var signed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.borderWidth = 2.0
        self.view.layer.cornerRadius = 2.0
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.clipsToBounds = true
        
        
        print(MAXFLOAT)
        print(Double.greatestFiniteMagnitude)
        print(Int.max);
        
    }

    @IBAction func plusOrMinusButtonAction(_ sender: UIButton) {
        
        animateLabel()
        if self.text != "0"{
            self.signed = true
            if text.first == "-"{
                let index = self.text.index(self.text.startIndex, offsetBy: 0, limitedBy: self.text.endIndex)
                self.text.remove(at: index!)
                assignValueToLabel(self.text)
            }else{
                assignValueToLabel("-"+self.text)
            }
        }
        if firstValue == result{
            self.firstValue = nil
        }
    }
    @IBAction func percentageButtonAction(_ sender: UIButton) {
        
        self.firstValue = self.text
        self.operation = Action.Division
        self.mathId = Action.Division.rawValue
        self.secondValue = "100"
        self.findTheResult(firstValue: self.firstValue!, secondValue: self.secondValue!, operation: self.operation!)
        
    }

    
    @IBAction func clearButtonAction(_ sender: UIButton) {
        
        sender.setTitle("AC", for: .normal)
        animateLabel()
        if self.mathId == nil && self.text == "0"{
            self.assignValueToLabel("0")
            self.firstValue = nil
            self.secondValue = nil
            self.result = nil
            self.operation = nil
        }
        if self.firstValue != nil{
            self.signed = false
            if self.operation != nil && self.text != "0"{
                self.assignValueToLabel("0")
                self.secondValue = nil
                self.operation = nil
                return
            }
            if self.mathId != nil{
                self.removeBorderForButton()
                self.mathId = nil
                self.operation = nil
                return
            }
            
        }
        
        if self.signed {
            self.signed = false
            return
        }
        
        self.assignValueToLabel("0")
        
    }
    
    private func assignValueToLabel(_ value:String) {
        self.label.text = value
        self.text = value
        if value.count <= 39{
            self.label.adjustsFontSizeToFitWidth = true
        }
    }
    private func animateLabel(){
        self.label.alpha = 0.1
        UIView.animate(withDuration: 0.3, animations: {
            self.label.alpha = 1.0
        })
    }
    
    
    @IBAction func numbersButtonsAction(_ sender: UIButton) {
        
        self.clearButton.setTitle("C", for: .normal)
        if mathId == nil{
            self.firstValue = nil
        }
        if self.result != nil{
            self.text = "0"
            self.result = nil
        }
        
        if self.firstValue != nil{
            if self.mathId != nil{
                self.operation = Action.init(rawValue: self.mathId!)
            }
        }
        
        if self.text == "0"{
            assignValueToLabel(sender.currentTitle! == "." ? "0." : sender.currentTitle!)
        }else{
            
            if self.text.count < 39{
                assignValueToLabel(self.text+sender.currentTitle!)
            }else{
                assignValueToLabel(self.text+"0")
            }
        }
        
    }
    
    @IBAction func operatorsAction(_ sender: UIButton) {
        
        self.signed = false
        self.animateLabel()
        self.mathId = sender.tag
        
        self.addBorderForSelected(sender)
        
        guard let first = self.firstValue else{
            self.firstValue = self.text
            self.text = "0"
            return
        }
        if let res = self.result, res == first{
            self.text = "0"
        }
        guard let oper = self.operation else {
            return
        }
        
        self.secondValue = self.text
        self.findTheResult(firstValue: first, secondValue: self.secondValue!, operation: oper)
        self.operation = nil
        
    }
    
    @IBAction func resultButtonAction(_ sender: UIButton) {
        
        self.removeBorderForButton()
        self.signed = false
        self.animateLabel()
        guard let first = self.firstValue else {
            self.text = "0"
            return
        }
        if self.operation != nil || self.mathId != nil{
            if let id = self.mathId{
                self.operation = Action.init(rawValue: id)
            }
            if self.result == nil{
                self.secondValue = self.text
            }
            self.findTheResult(firstValue: first, secondValue: self.secondValue!, operation: self.operation!)
            self.mathId = nil
        }
    }
    
    private func findTheResult(firstValue:String, secondValue:String, operation:Action){
        if let first = Double(firstValue), let second = Double(secondValue){
            let result:Double!
            switch operation {
            case .Addition:
                result = first + second
            case .Subtraction:
                result = first - second
            case .Multiply:
                result = first * second
            case .Division:
                result = first / second
                
            }
            
            let output:String = String(result)
            let array = output.components(separatedBy: ".")
            self.result = output
            if array.last == "0"{
                self.result = array.first
            }
            self.assignValueToLabel(self.result!)
            self.firstValue = self.result
            
        }
        
    }
    
    private func addBorderForSelected(_ button:UIButton) {
        
        self.removeBorderForButton()
        
        button.layer.borderColor = UIColor.customColorsWith(red:94,green:94,blue:94).cgColor
        button.layer.borderWidth = 1.5
        self.label.alpha = 0.2
        UIView.animate(withDuration: 0.4, animations: {
            self.label.alpha = 1.0
        })
        
    }
    private func removeBorderForButton() {
        for vw in self.view.subviews {
            vw.layer.borderWidth = 0
            vw.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
extension UIButton{
    
    override open var isHighlighted: Bool{
        didSet{
            self.alpha = isHighlighted ? 0.6 : 1.0
        }
    }
    override open var isSelected: Bool{
        didSet{
            self.alpha = isSelected ? 0.6 : 1.0
        }
    }
    
}
extension UIColor{
    
    class func customColorsWith(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor {
        let color = UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
        return color;
    }
}

