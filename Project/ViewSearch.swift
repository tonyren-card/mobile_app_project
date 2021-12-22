//
//  ViewSearch.swift
//  iosCard
//
//  Created by Tony Ren on 2021-01-31.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class ViewSearch: Search {
    
    var cardDel: CardDelegate?
    
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
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searchText.isEmpty {
//            return 0
//        }
//        return filteredcards.count
//    }
    
    //Set up cell appearance
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = filteredcards[indexPath.row].getCarName()
//        return cell
//    }
    
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
        self.mySearchController.searchBar.becomeFirstResponder()
    }
    
    
    
    func dispCardAct(_ x: Int){
        if mySearchController.isActive{
            //Dismiss
            self.mySearchController.dismiss(animated: false, completion: {
                //Segue
                self.present(self.filteredcards[x], animated: true)
                //Delegate
                self.filteredcards[x].delegate = self.cardDel
                self.filteredcards[x].updateAddDelButton()
            })
        }
    }
}
