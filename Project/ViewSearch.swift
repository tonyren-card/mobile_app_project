//
//  ViewSearch.swift
//  iosCard
//
//  Created by Tony Ren on 2021-01-31.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class ViewSearch: UITableViewController {
    
    @IBOutlet var tableViewCont: UITableView!
    
    var searchText:String = ""
    var mySearchController = UISearchController()
    var mySearchBar: UISearchBar?
    
    var mainController: CardDelegate?
    
    var cards: [Card] = []
    var filteredcards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        mySearchBar?.placeholder = "e.g. \"honda\", \"civic\", \"honda civic\""
        
        self.mySearchController.isActive = true
        self.mySearchController.delegate = self
        self.mySearchBar?.delegate = self
        
        loadData()
    }
    
    //UITableViewController override definitions
    //Touch up cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dispCardAct(indexPath.row)
    }
    
    //Set up number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchText.isEmpty {
            return 0
        }
        return filteredcards.count
    }
    
    //Set up cell appearance
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredcards[indexPath.row].getCarName()
        return cell
    }
    
    //Swipe to left action
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !self.filteredcards[indexPath.row].isAdded() {
            let action = UIContextualAction(style: .normal, title: "Add to Library") { [weak self] (action, view, completionHandler) in self?.mainController?.addCard(cardObject: (self?.filteredcards[indexPath.row])!)
                completionHandler(true)
            }
            action.backgroundColor = .systemBlue
        
            //Delegate
            self.filteredcards[indexPath.row].delegate = self.mainController
            
            //Load API
            self.filteredcards[indexPath.row].loadAPIImageLink()
        
            return UISwipeActionsConfiguration(actions: [action])
        }
        return nil
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
        if searchText.isEmpty{
            tableViewCont.reloadData()
            return
        }
        self.filteredcards.removeAll()
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
    
    func dispCardAct(_ x: Int){
        if mySearchController.isActive{
            //Dismiss
            self.mySearchController.dismiss(animated: false, completion: {
                //Segue
                self.present(self.filteredcards[x], animated: true)
                //Delegate
                self.filteredcards[x].delegate = self.mainController
                self.filteredcards[x].updateAddDelButton()
            })
        }
    }
    
}

extension ViewSearch: UISearchControllerDelegate{
    func didPresentSearchController(_ searchController: UISearchController) {
        self.mySearchController.searchBar.becomeFirstResponder()
    }
    
}

extension ViewSearch: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.searchText = searchBar.text!
//
//        self.scrapeData()
//    }
        
}

extension ViewSearch: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        self.searchText = text
        scrapeData()
    }
    
}
