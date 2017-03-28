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
    
    @IBOutlet weak var locationPostingStackView: UIStackView!
    @IBOutlet weak var mediaURLPostingStackView: UIStackView!
    
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil) // go back to mapVC/ StudentsTVC
    }
    
    @IBAction func findOnMapBtnPressed(_ sender: Any) {
        // geocode location string -> latitude + longtitude -> pass as var to MKMapView @ POST url view -> at that view, u add Mapview there.
        if locationInput.text!.isEmpty {
            debugArea.text = "Location cannot be blank"
            // view stays...
        } else {
            let location = locationInput.text
            print("location is \(location)")
            // do geocoding, find the map
            
            // when geocoding is successful, pass geocoding data to a func that does map showingn- save latitiude, longitude as var - easier for retrieving later
            
            
            
            // call several calls here
            // 1. get a student location
            // if nil call 2. POST a student location
            // if != nil, 3. PUT a student location
            
            
            // after saving var is done, bring user to the view 2.
            locationPostingStackView.isHidden = true
            mediaURLPostingStackView.isHidden = false
            // UIView.animateWithDuration - to add fading effect
            
            // no need for below - because both views share the SAME view controller....
            //  when data is passed, bring to next controller.
            // let controller = self.storyboard!.instantiateViewController(withIdentifier: "MediaPostingViewController")
            // self.present(controller, animated: true, completion: nil)

            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugArea.text = ""
        locationPostingStackView.isHidden = false
        mediaURLPostingStackView.isHidden = true
        
        // just for testing - delete after !
        //locationPostingStackView.isHidden = true
        //mediaURLPostingStackView.isHidden = false
        
        
    }
 
    


}
