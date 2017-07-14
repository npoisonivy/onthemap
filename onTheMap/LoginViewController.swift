//
//  LoginViewController.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
       
    // MARK: Properties
//    var appDelegate: AppDelegate! - We can either place info such as sessionID, userID @ appDelegate, but I choose to store it @ UdacityClient.swift where stores everything a client does = make GET/ POST request "taskforGETRequest", etc
    var keyboardOnScreen = false
    var session: URLSession!
//    var udacityClass: UdacityClient? = UdacityClient() // so i can call class UdacityClient's (for logged in user) properties there - ex: UserID, firstName, lastName
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var signUpLink: UITextView! // sign up link
    @IBOutlet weak var debugTextLabel: UILabel!
    // why does my favoritemovies app has this - @IBOutlet weak var movieImageView: UIImageView! ?? do i need one for Udacity image?
    
    // name the delegates
//     let emailTextDelegate = Text

    let emailDelegate = TextFieldDelegate()
    let passwordDelegate = TextFieldDelegate()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad() // what does this mean?
        
        // MARK: Declare each textField's delegate
        self.emailTextField.delegate = self.emailDelegate
        self.passwordTextField.delegate = self.passwordDelegate
        
        // configureBackground() - do i need this ?? what is the code for "orange"? This is for blue
        
        // MARK: Label - partially clickable link
        // signUpLink - @IBOutlet weak var signUpLink: UILabel! // sign up link
        
        // Attributed String for Label
        let plainText = "Don't have an account? Sign Up" // - ok
        let styledText = NSMutableAttributedString(string: plainText) // convert string to mutableattributestring -> so u can call class "NSMutableAttributedString" - OK
        
        
        // Set Attribuets for Color, HyperLink and Font Size
        // Option 1
        // let attributes = [NSLinkAttributeName: NSURL(string: "https://www.udacity.com/account/auth#!/signup")!, NSForegroundColorAttributeName: UIColor.blue]
        // styledText.setAttributes([String : Any]?, range: <#T##NSRange#>)
        // styledText.setAttributes(attributes, range: NSMakeRange(23, 7))
        
        // Option 2
        // below line of code replaces 2 lines of code above - set URL + NSRange!
        styledText.addAttribute(NSLinkAttributeName, value: "https://www.udacity.com/account/auth#!/signup", range: NSRange(location: 23, length: 7))
        
        signUpLink.attributedText = styledText
      
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // do i even need this ?
        emailTextField.text = ""
        passwordTextField.text = ""
        setUIenabled(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // debugTextLabel.text = "hello"   // nothing to start with
    }
    
    // MARK: Actions
    @IBAction func loginPressed(_ sender: AnyObject) {  // i have to change from "Any" to "AnyObject"
//        userDidTapView(self)  - add this for textfield delegate
        
        // did this go through ?
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayError("Email or Password is Empty!")
            // debugTextLabel.text = "Email or Password is Empty!"
            return
        } else { // if everything is filled...
            
            setUIenabled(false) // disable email, pw, loginbutton everything while sending networking request
            
            // set & save username, password to class UdacityClient, so I can retrieve anywhere from other pages - like "UdacityConvenience"
            UdacityClient.sharedInstance().username = emailTextField.text
            UdacityClient.sharedInstance().password = passwordTextField.text
            
            print("udacityClient?.username is... \(                                                                                                                                                                                                     UdacityClient.sharedInstance().username)")  // udacityClient?.username is... nil
            print("udacityClient?.password is... \(UdacityClient.sharedInstance().password)")  // udacityClient?.username is... nil
            
//             5/1 - comment it out to help debugging for getUserID()
            UdacityClient.sharedInstance().authenticateWithViewController(self) {(success, errorString) in
                performUIUpdatesOnMain {
                    if success { // when I pass success/ error to authenticateWithViewController's completion handler
                        self.completeLogin()
                    } else {
                        self.displayError(errorString) // errorString from either getUserID or getPublicData
                        // alertVC, message: errorString
                        self.setUIenabled(true)
                    }
                } // end of performUIUpdatesOnMain
            } // end of authenticateWithViewController
        } // END of if/ else
        
    // make the request to Udacity for authentication - send POST email, password to parse server - to get session id -> so what am i going to do with that session id?
//            UdacityClient.sharedInstance().authenticateWithUserCredentials(emailTextField.text!, passwordTextField.text!)
        
//        // Testing this to make sure if userID is retrieved first before moving it under getPublidData() @ UdacityConvenience.swift
//        UdacityClient.sharedInstance().getUserID(UdacityClient.sharedInstance().username!, UdacityClient.sharedInstance().password!, { (success, userID, errorString) in
//            // deal with success, userID returned back to here
//            print("userID is", userID)
//            UdacityClient.sharedInstance().userID = userID
//        })
//        
        
        
        
        // above will return "error"/ "success" back to here.
        // if error, then debugTextLabel.text = "Incorrect password/ username"
    
      
    }  // end of loginPressed

    
    
    
            

            // should grab the "user id" = unique key from struct [student]
            // and pass that struct student's user id to below getPublicUserData(Student.user_id)
//            let result = UdacityClient.sharedInstance().getPublicUserData()  // return result here...
        
                // when it comes back -> we should set a completion handler to listen to success/ errorString -> need to set up success/ errorString to be passed by authenticateWithUserCredentials!
            
                // performUIUpdatesOnMain {
//            if success {
//            self.comleteLogin()
//                else
//            self.displayErrory(errorString - that is being passed)
            
    
// *** uncomment below after this func is being mentioned + TabbedViewController is created on MSB
    private func completeLogin() {
        debugTextLabel.text = ""
//        let controller = storyboard!.instantiateViewController(withIdentifier: "TabbedViewController") as! UITabBarController - it doesn't show the TabbedBar at the top
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabbedNavigationController") as! UINavigationController
        
        print("controller is ...\(controller)")
        present(controller, animated: true, completion: nil)
    } // end of completeLogin
} // end of class LoginViewController



// MARK: - LoginViewController (Configure UI)
private extension LoginViewController {
    func setUIenabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            
            // set UI alertVC
            let errorAlert = UIAlertController(title: "Failure", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                // what happens after "OK" is pressed? - dismiss the alertbox - back to original login page
                errorAlert.dismiss(animated: true, completion: nil)
            }))
            
            // need to call alert to present
            performUIUpdatesOnMain {
                self.present(errorAlert, animated: true, completion: nil) // have to place any interface code on mainQueue
            }
        }
    } // End of func displayError()
    
    func subscribeToKeyboardNotifications() {
        // write func "keyboardWillShow"/ "keyboardWillHide"  - detect when UI triggers KB to show/ hide -> then contoller triggers our own func "keyboardWillShow"/ "keyboardWillHide"
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // even when KBWillshow is detected - still need to see what to do based on whats going on with the textfield
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if emailTextField.isFirstResponder || passwordTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        } else {
            reset()
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        reset()
    }
    
    // pass notification from KBWillshow to getKeyboardHeight() -> trigger this func to run, and return KB's height back to KBWillShow func
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // Userinfo contains KB's frame info
        return keyboardSize.cgRectValue.height
    }
    
    func reset() {
        self.view.frame.origin.y = 0
    }
    
    func unsubscribeToKeyboardNotifications() {
        // remove notification from system - not listening to UIKeyboardWillShow/ Hide anymore
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}

    // I didn't add below in - as it's related to UI, front end
//    func configureUI() {
//        
//        // configure background gradient
//        let backgroundGradient = CAGradientLayer()
//        backgroundGradient.colors = [Constants.UI.LoginColorTop, Constants.UI.LoginColorBottom]
//        backgroundGradient.locations = [0.0, 1.0]
//        backgroundGradient.frame = view.frame
//        view.layer.insertSublayer(backgroundGradient, at: 0)
//        
//        configureTextField(usernameTextField)
//        configureTextField(passwordTextField)
//    }
//    
//    func configureTextField(_ textField: UITextField) {
//        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
//        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
//        textField.leftView = textFieldPaddingView
//        textField.leftViewMode = .always
//        textField.backgroundColor = Constants.UI.GreyColor
//        textField.textColor = Constants.UI.BlueColor
//        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
//        textField.tintColor = Constants.UI.BlueColor
//        textField.delegate = self
//    }
//}


