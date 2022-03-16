//
//  Search.swift
//  iosCard
//
//  Created by Tony Ren on 2021-12-14.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

protocol SearchElements{
    var brands: [String] { get set }
}

class Search: UITableViewController, SearchElements{
    
    @IBOutlet var tableViewCont: UITableView!
    
    var searchText:String = ""
    var mySearchController = UISearchController()
    var mySearchBar: UISearchBar?
    
    var mainController: SearchDelegate?
    
    var cards: [Card] = []
    var filteredcards: [Card] = []
    var brands: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewCont.delegate = self
        tableViewCont.dataSource = self

        self.mySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchBar.text = self.searchText
//            controller.hidesNavigationBarDuringPresentation = false
//            controller.automaticallyShowsCancelButton = false
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        mySearchBar = mySearchController.searchBar
        
//        self.mySearchController.isActive = true
        self.mySearchController.delegate = self
        self.mySearchBar?.delegate = self
        self.tableViewCont.keyboardDismissMode = .onDrag
        
        loadData()
    }

    // MARK: - Table view data source
    //Touch up cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // behaviour when tapped for child class
    }
    
    //Cell count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredcards.count
    }

    //Cell appearance
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredcards[indexPath.row].getCarName()
        return cell
    }

    
    
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
                //Create card
                foundCarInfo = line.components(separatedBy: ",")
                createcard(foundCarInfo!)
                
                //Add brand to brands
                if (!brands.contains(foundCarInfo![0])){
                    brands.append(foundCarInfo![0])
                }
            }
            print(brands)
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
        self.filteredcards.removeAll()
        if searchText.isEmpty{
            tableViewCont.reloadData()
            return
        }
        for card in cards{
            if (card.getCarName().lowercased().starts(with: self.searchText.lowercased()) || card.getCarModel().lowercased().starts(with: self.searchText.lowercased())){
                if let existing = mainController?.getCard(equals: card.getCarName()) {
                    self.filteredcards.append(existing)
                }else{
                    self.filteredcards.append(card)
                }
            }
        }

        tableViewCont.reloadData()
    }


}

extension Search: UISearchControllerDelegate{
    func didPresentSearchController(_ searchController: UISearchController) {
        //If a child class needs special start up
    }
    
}

extension Search: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.mySearchBar?.endEditing(true)
    }
        
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
