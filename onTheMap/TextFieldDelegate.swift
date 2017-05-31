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
        if textField.placeholder == "Email" || textField.placeholder == "Password" || textField.placeholder == "City here" || textField.placeholder == "Enter Your Media URL here" {
            textField.placeholder = ""
        }
    }
    
    // when user taps another extfield
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.resignFirstResponder()
        // when user taps another textfield without typing anything, placeholder will show..
        if textField.placeholder!.isEmpty {
            if textField.tag == 0 {
                textField.placeholder = "City here"
            } else if textField.tag == 1 {
                textField.placeholder = "Enter Your Media URL here"
            } else if textField.tag == 2 {
                textField.placeholder = "Email"
            } else {  // tag = 3
                textField.placeholder = "Password"
            }
        }
    }
    
    // VERY IMPORTANT - to capture new user's input after a failed submission - user reenter a new value in textfield on UI -> DOES NOT MEAN that when they enter it, our code is going to register the NEW value! -> we must call shouldchangeCharactersIn -> to REALLY "register" the NEW value!
    // either we set "Email/ Password" as placeholder / real text, we need this func regardless
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString
        newText = textField.text! as NSString // grab whatever user entered
        newText = newText.replacingCharacters(in: range, with: string) as NSString // "range" is listened by textfield on UI when user enters -> 1. user enter "abc" -> it will replace the orignal "Email" 2. Then user enter xxx -> it then replaces "abc" without having user to kill the app so that app can recapture
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        /* may not need it as i am using placeholder?? -> still need it ->
         reason: if not -> then placeholder is GONE and never comes back
         tag no - 0 location, 1 mediaURL, 2 email 3 password  - needs tag to identify which textfield is tapped */
       
       // finish it here ...
        if textField.placeholder!.isEmpty {
            if textField.tag == 0 {
                textField.placeholder = "City Here"
            } else if textField.tag == 1 {
                textField.placeholder = "MediaURL Here"
            } else if textField.tag == 2 {
                textField.placeholder = "Email"
            } else {  // tag = 3
                textField.placeholder = "Password"
            }
        }
        
        /*if (textField.text!.isEmpty) && textField.tag == 1 {
            textField.text = "Top"
        } else if (textField.text!.isEmpty) && textField.tag == 2 {
            textField.text = "Bottom"
        } */
        return true
    }
}













