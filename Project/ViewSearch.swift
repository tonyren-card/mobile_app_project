//
//  SwiftUIView.swift
//  Project
//
//  Created by Tony Ren on 2021-01-31.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class ViewSearch: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var searchText:String = ""
    var mySearchController = UISearchController()
    var mySearchBar: UISearchBar?
    
    var mainController: ViewController?
    var scrapeCard: Card? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text!
        
        self.scrapeData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        print(text)
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
            
            var foundCarInfo: [String]? = nil
            
            //Data gets collected
            for line in lines{
                if firstLine{
                    firstLine = false
                    continue
                }
                let blocks = line.components(separatedBy: ",")
                let lineSpaced = blocks.joined(separator: " ")
                
                if (lineSpaced.range(of: self.searchText, options: .caseInsensitive) != nil){
                    print(line)
                    foundCarInfo = blocks
                    break
                }
            }
            
            //If no car found
            guard let checkString = foundCarInfo, !checkString.isEmpty else{
                self.scrapeCard = Card()
                self.dispCardAct()
                return
            }
            
            //Data gets presented
            var sales = ""
            if let floatSales = Float(String((foundCarInfo?[2])!)){
                sales = String(format: "%.0f units", floatSales*1000)
            }else{
                sales = String((foundCarInfo?[2])!)
            }
            
            var price = ""
            if let floatPrice = Float(String((foundCarInfo?[5])!)){
                price = String(format: "$%.2f", floatPrice*1000)
            }else{
                price = String((foundCarInfo?[5])!)
            }
            
            self.scrapeCard = Card(carName: "\(String((foundCarInfo?[0])!)) \(String((foundCarInfo?[1])!))", carSales: sales, carType: String((foundCarInfo?[4])!), carPrice: price, carHP: String((foundCarInfo?[7])!), carEngine: String((foundCarInfo?[6])!), carWB: String((foundCarInfo?[8])!), carFuel: "\(String((foundCarInfo?[13])!)) mpg", carCap: String((foundCarInfo?[12])!), carLaunch: String((foundCarInfo?[14])!), carImg: String((foundCarInfo?[16])!))
            
            self.dispCardAct()
            
        }catch{
            print("File read error for file \(filepath)")
        }
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
