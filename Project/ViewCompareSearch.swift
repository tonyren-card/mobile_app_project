//
//  ViewCompareSearch.swift
//  iosCard
//
//  Created by Tony Ren on 2021-12-06.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class ViewCompareSearch: UITableViewController {
    var addQuery: CChar? = -1
    var vcDelegate: CompareDelegate?
    var compDelegate: QueryDelegate?
    
    @IBOutlet var tableViewCont: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewCont.delegate = self
        tableViewCont.dataSource = self
        
        print("Add Query=\(addQuery!)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return vcDelegate!.getLibrarySize()
//    }

    //Number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vcDelegate!.getLibrarySize()
    }

    //Cell Apperance
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellToCompare", for: indexPath)

        cell.textLabel?.text = vcDelegate?.getLibrary()[indexPath.row].getCarName()

        return cell
    }
    
    //Touch up cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.compDelegate?.setCard(for: self.addQuery!, card: (vcDelegate?.getLibrary()[indexPath.row])!)
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}