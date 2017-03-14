//
//  StudentsTableViewController.swift
//  onTheMap
//
//  Created by Nikki L on 3/3/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    // somehow, here needs to expect the [students] being passed by "getStudentsLocations's completion handler" -> return studentlocation in Struct & error, so we can use it to display below...
    
    var locations: [StudentLocation] = [StudentLocation]() // prepare its type as struct -> prepares it to received the value from "getStudentLocations(C.H. returns: studentlocation, error)"
    
    @IBOutlet weak var studentsLocationsTableView: UITableView!  // for calling reload data later

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationItem.title = "On The Map"
    }
    
    //  need to populate data here before this page is loaded
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // call get student locations
        // return -> pass to
        
        // property viewControllers[0] -> map view controller
        // [1] tableviewcewcontroller // search for -- Tab bar controller view cotrnollers
        // "data" got reloaded @ Students TableView Controller.
        
        // call GET all students' locations
        UdacityClient.sharedInstance().getStudentsLocations { (studentslocations, error) in
            if let locations = studentslocations { // if namethisanything is != nil - being passed back from getStudentsLocations' completion handler
                self.locations = locations
                performUIUpdatesOnMain {
                    self.studentsLocationsTableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
//        return students.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//        let student = students[(indexPath as NSIndexPath).row]
        // Configure the cell...
        cell.textLabel?.text = "Selection \(indexPath.section) Row\(indexPath.row)"
//        cell?.firstname = student.firstname
//        cell?.lastname = student.lastname
        
        return cell
    }
    
    // also need to listen - if a student is click -> open url or "media url"
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
