//
//  MediaPostingViewController.swift
//  onTheMap
//
//  Created by Nikki L on 3/6/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit
import MapKit

class MediaPostingViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mediaMapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
