//
//  SwiftUIView.swift
//  Project
//
//  Created by Tony Ren on 2021-01-31.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class ViewSearch: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet var tableViewCont: UITableView!
    
    var searchText:String = ""
    var mySearchController = UISearchController()
    var mySearchBar: UISearchBar?
    
    var mainController: ViewController?
    
    var filteredcards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
        tableViewCont.delegate = self
        tableViewCont.dataSource = self
        
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
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        self.mySearchController.searchBar.becomeFirstResponder()
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.searchText = searchBar.text!
//
//        self.scrapeData()
//    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        print(text)
        self.searchText = text
        scrapeData()
    }
    
    func scrapeData(){
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
            var donefounding = false
            
            var foundCarInfo: [String]? = nil
            
            self.filteredcards.removeAll()
            //Data gets collected
            for line in lines{
                if firstLine{
                    firstLine = false
                    continue
                }
                foundCarInfo = line.components(separatedBy: ",")
                let lineSpaced = foundCarInfo!.joined(separator: " ")
                
                if (lineSpaced.starts(with: self.searchText)){
                    donefounding = true
                    createcard(foundCarInfo!)
                }else if (donefounding == true) {
                    break
                }
            }
            
            //If no car found
            /*guard let checkString = foundCarInfo, !checkString.isEmpty else{
                self.scrapeCard = Card()
                self.dispCardAct()
                return
            }*/
            
            
            
            self.dispCardAct()
            
        }catch{
            print("File read error for file \(filepath)")
        }
    }
    
    private func createcard(_ data: [String]){
        //Data gets presented
        var sales = ""
        if let floatSales = Float(String((data[2]))){
            sales = String(format: "%.0f units", floatSales*1000)
        }else{
            sales = String((data[2]))
        }
        
        var price = ""
        if let floatPrice = Float(String((data[5]))){
            price = String(format: "$%.2f", floatPrice*1000)
        }else{
            price = String((data[5]))
        }
        
        let card = Card(carName: "\(String((data[0]))) \(String((data[1])))", carSales: sales, carType: String((data[4])), carPrice: price, carHP: String((data[7])), carEngine: String((data[6])), carWB: String((data[8])), carFuel: "\(String((data[13]))) mpg", carCap: String((data[12])), carLaunch: String((data[14])), carImg: String((data[16])))
        
        self.filteredcards.append(card)
    }
    
    func dispCardAct(){
        if mySearchController.isActive{
            //Dismiss
            self.mySearchController.dismiss(animated: false, completion: {
                //Segue
                self.present(self.scrapeCard!, animated: true)
                //Delegate
                self.scrapeCard?.delegate = self.mainController
                //Display
                self.scrapeCard?.setDisplayText()
            })
        }
    }
    
}
