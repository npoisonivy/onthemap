//
//  InformationPostingViewController.swift
//  onTheMap
//
//  Created by Nikki L on 2/28/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var debugArea: UILabel!
    
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findOnMapBtnPressed(_ sender: AnyObject) {
        // call a func to check if location is empty, and do geocoding
        if locationInput.text!.isEmpty {
            debugArea.text = "Location cannot be blank."
        } else {
            // do geocoding, find the map
            
            
            // when geocoding is done, pass geocoding data to a func that does map shoing
            
            
            //  when data is passed, bring to next controller.
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MediaPostingViewController") 
            self.present(controller, animated: true, completion: nil)
        
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugArea.text = ""
        
        
        
        
        
    }

}
