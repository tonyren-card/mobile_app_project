//
//  ViewSearch.swift
//  iosCard
//
//  Created by Tony Ren on 2021-01-31.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

protocol ViewSearchDelegate {
    func advancedFilterData(struct criteria: AdvancedSearchCriteria)
}

class ViewSearch: Search, ViewSearchDelegate {
    
    var cardDel: CardDelegate?
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySearchBar?.placeholder = "e.g. \"honda\", \"civic\", \"honda civic\""
    }
    
    //UITableViewController override definitions
    //Touch up cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        //Show card of selected cell
        dispCardAct(indexPath.row)
    }
    
    //Set up number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredcards.count
    }
    
    //Set up cell appearance
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = filteredcards[indexPath.row].getCarName()
//        return cell
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let asc = segue.destination as? AdvancedSearch{
            asc.searchDelegate = self
            asc.searchElements = self
        }
    }
    
    //Swipe to left action
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !self.filteredcards[indexPath.row].isAdded() {
            let action = UIContextualAction(style: .normal, title: "Add to Library") { [weak self] (action, view, completionHandler) in self?.cardDel?.addCard(cardObject: (self?.filteredcards[indexPath.row])!)
                completionHandler(true)
            }
            action.backgroundColor = .systemBlue
        
            //Delegate
            self.filteredcards[indexPath.row].delegate = self.cardDel
            
            //Load API
            self.filteredcards[indexPath.row].loadAPIImageLink()
        
            return UISwipeActionsConfiguration(actions: [action])
        }
        return nil
    }
    
    //Set search bar as first responder
    override func didPresentSearchController(_ searchController: UISearchController) {
        // no longer keyboard appears on start
//        self.mySearchController.searchBar.becomeFirstResponder()
    }
    
    
    
    func dispCardAct(_ x: Int){
        if mySearchController.isActive{
            //Dismiss
            self.mySearchController.dismiss(animated: false, completion: nil)
        }
        //Segue
        self.present(self.filteredcards[x], animated: true)
        //Delegate
        self.filteredcards[x].delegate = self.cardDel
        self.filteredcards[x].updateAddDelButton()
    }
    
    func advancedFilterData(struct criteria: AdvancedSearchCriteria){
        self.filteredcards.removeAll()
        
        for card in cards{
            let cardDate = formatter.date(from: card.getLatestLaunch())!
            if (card.getCarName().lowercased().starts(with: criteria.make.lowercased())
                && (criteria.priceRange[0] <= card.getPriceFloat() && card.getPriceFloat() <= criteria.priceRange[1])
                && (criteria.engineRange[0] <= card.getEngineSizeFloat() && card.getEngineSizeFloat() <= criteria.engineRange[1])
                && (criteria.hpRange[0] <= card.getHorsePowerFloat() && card.getHorsePowerFloat() <=  criteria.hpRange[1])
                && (criteria.wbRange[0] <= card.getWheelBaseFloat() && card.getWheelBaseFloat() <= criteria.wbRange[1])
                && (criteria.feRange[0] <= card.getFuelEffFloat() && card.getFuelEffFloat() <= criteria.feRange[1])
                && (criteria.fcRange[0] <= card.getFuelCapFloat() && card.getFuelCapFloat() <= criteria.fcRange[1])
                && (criteria.salesRange[0] <= card.getSalesFloat() && card.getSalesFloat() <= criteria.salesRange[1])
                && (criteria.launchRange[0]! <= cardDate && cardDate <= criteria.launchRange[1]!))
            {
                print(card.getCardObj())
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
