//
//  StudentsTableViewController.swift
//  onTheMap
//
//  Created by Nikki L on 3/3/17.
//  Copyright © 2017 Nikki. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    // somehow, here needs to expect the [students] being passed by "getStudentsLocations's completion handler" -> return studentlocation in Struct & error, so we can use it to display below... "return StudentModel.sharedInstance().listofStudents.count"
    
    @IBOutlet weak var studentsLocationsTableView: UITableView!  // for calling reload data later

    override func viewDidLoad() {
        super.viewDidLoad()
        print("****StudentsTableVC's viewDidLoad is called ")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        print("when user clicks tableView icon, code on that file will execute")
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationItem.title = "On The Map"

        
//        print("StudentTableView's (from viewwillappear) StudentModel.sharedInstance().listofStudents.count is.. \(self.locations.count)") // #100 when refresh button is clicked...but 0 when i click back and forth the map, table icon....
    } // end of viewDidLoad
    
    //  need to populate data here before this page is loaded
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("****StudentsTableVC's viewWillAppear is called ")
    } // end of viewWillAppear
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print("@ tableVC, locations passed is \(self.locations)")
        return StudentModel.sharedInstance().listofStudents.count
    }

    // to display data of each user - from self.locations on this page.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let student = StudentModel.sharedInstance().listofStudents[(indexPath as NSIndexPath).row] // that serve "for loop" to loop thr 100 locations
        
        // cell.textLabel?.text = "Selection \(indexPath.section) Row\(indexPath.row)"
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)" // individual students here
        // need to insert a link to open the safari.
        
        
        return cell
    } // end of tableView
    
    // use #didSelectRowAt to listen - if a student is clicked -> open "media url" from safari
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.sharedInstance().listofStudents[(indexPath as NSIndexPath).row]
        
        // change state of element from didSelect to deselect (= reset state)
        tableView.deselectRow(at: indexPath, animated: true)

        let app = UIApplication.shared
        let url = URL(string: student.mediaURL)!
        
        // check if url has good format before opening
        if app.canOpenURL(url) {
            app.open(url)
        } else {
            print("mediaURL can be opened", app.canOpenURL(url))
            
            // show alert
            let failedURLAlert = UIAlertController(title: "Failure", message: "URL cannot be opened", preferredStyle: UIAlertControllerStyle.alert)
            
            failedURLAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                failedURLAlert.dismiss(animated: true, completion: nil)
                
                self.dismiss(animated: true, completion: nil) // go back to the StudentsTableViewController
            }))
            
            performUIUpdatesOnMain {
                self.present(failedURLAlert, animated: true, completion: nil)
            }
            
        } // END of if/ else
        
    } // end of tableview "didSelectRowAt"
    
    
} // end of class StudentsTableViewController
