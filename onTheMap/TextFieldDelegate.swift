//
//  TextFieldDelegate.swift
//  onTheMap
//
//  Created by Nikki L on 5/29/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // may need to 1. delete placeholder word 2. and add "textfield.text - 'Email/ Password'" under "viewWillAppear"
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // instead of calling "textField.text" -> we use "textField.placeholder"
        if textField.placeholder == "Email" || textField.placeholder == "Password" {
            textField.placeholder = ""
        }
    }
    
    // either we set "Email/ Password" as placeholder / real text, we need this func regardless
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString
        newText = textField.text! as NSString // grab whatever user entered
        newText = newText.replacingCharacters(in: range, with: string) as NSString // "range" is listened by textfield on UI when user enters -> 1. user enter "abc" -> it will replace the orignal "Email" 2. Then user enter xxx -> it then replaces "abc" without having user to kill the app so that app can recapture
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        // may not need it as i am using placeholder??
       /* if (textField.text!.isEmpty) && textField.tag == 1 {
            textField.text = "Top"
        } else if (textField.text!.isEmpty) && textField.tag == 2 {
            textField.text = "Bottom"
        }*/
        return true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    

}













