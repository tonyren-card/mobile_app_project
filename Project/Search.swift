//
//  Search.swift
//  iosCard
//
//  Created by Tony Ren on 2021-12-14.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class Search: UITableViewController {
    
    var searchText:String = ""
    var mySearchController = UISearchController()
    var mySearchBar: UISearchBar?
    
    var cards: [Card] = []
    var filteredcards: [Card] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchBar.text = self.searchText
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        mySearchBar = mySearchController.searchBar
        
        self.mySearchController.isActive = true
        self.mySearchController.delegate = self
        self.mySearchBar?.delegate = self
        
        loadData()
    }

    // MARK: - Table view data source
    //Touch up cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
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
    func loadData(){
        //CSV file opens
        let file = "Car_sales"
        
        guard let filepath = Bundle.main.path(forResource: file, ofType: "csv")
        else{
            print("error occured opening file \(file)")
            return
        }

        //Reading and processing CSV file
        do {
            let contents = try String(contentsOfFile: filepath)
            
            let lines = contents.components(separatedBy: "\n")
            var firstLine = true
            
            var foundCarInfo: [String]? = nil
            
            //Data gets collected
            for line in lines{
                if firstLine{
                    firstLine = false
                    continue
                }
                foundCarInfo = line.components(separatedBy: ",")
                createcard(foundCarInfo!)
            }
        }catch{
            print("File read error for file \(filepath)")
        }
    }
    
    private func createcard(_ data: [String]){
        //Data gets presented
        var sales = ""
        if let floatSales = Float(data[2]){
            sales = String(format: "%.0f units", floatSales*1000)
        }else{
            sales = data[2]
        }
        
        var price = ""
        if let floatPrice = Float(data[5]){
            price = String(format: "$%.2f", floatPrice*1000)
        }else{
            price = data[5]
        }
        
        let card = Card(carMake: data[0], carModel: data[1], carSales: sales, carType: data[4], carPrice: price, carHP: data[7], carEngine: data[6], carWB: data[8], carFuel: "\(data[13]) mpg", carCap: data[12], carLaunch: data[14])
        
        self.cards.append(card)
    }
    
    func scrapeData(){
//        if searchText.isEmpty{
//            tableViewCont.reloadData()
//            return
//        }
//        self.filteredcards.removeAll()
//        for card in cards{
//            if (card.getCarName().lowercased().starts(with: self.searchText.lowercased()) || card.getCarModel().lowercased().starts(with: self.searchText.lowercased())){
//                if let existing = mainController?.getCard(equals: card.getCarName()) {
//                    self.filteredcards.append(existing)
//                }else{
//                    self.filteredcards.append(card)
//                }
//            }
//        }
//
//        tableViewCont.reloadData()
    }


}

extension Search: UISearchControllerDelegate{
    func didPresentSearchController(_ searchController: UISearchController) {
        self.mySearchController.searchBar.becomeFirstResponder()
    }
    
}

extension Search: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.searchText = searchBar.text!
//
//        self.scrapeData()
//    }
        
}

extension Search: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        self.searchText = text
        scrapeData()
    }
    
}
