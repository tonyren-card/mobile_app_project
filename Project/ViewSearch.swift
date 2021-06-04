//
//  SwiftUIView.swift
//  Project
//
//  Created by Tony Ren on 2021-01-31.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class ViewSearch: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var searchText:String? = ""
    var mySearchController = UISearchController()
    var mySearchBar: UISearchBar?
    
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let send = segue.destination as? Scrape{
            send.searchCar = self.searchText ?? "Rand"
        }
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        self.mySearchController.searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text!
        
        performSegue(withIdentifier: "segueScrape", sender: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {

    }
}
