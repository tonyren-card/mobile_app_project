//
//  ViewCompareSearch.swift
//  iosCard
//
//  Created by Tony Ren on 2021-12-06.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class ViewCompareSearch: Search {
    var addQuery: CChar? = -1
    var vcDelegate: CompareDelegate?
    var compDelegate: QueryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySearchBar?.placeholder = "Search for cars not in library"
    }

    // MARK: - Table view data source
    
    //Touch up cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        // Add card to compare for corresponding query
        self.compDelegate?.setCard(for: self.addQuery!, card: (filteredcards[indexPath.row]))
        self.mySearchController.isActive = false
        self.dismiss(animated: true, completion: nil)
    }

    
    
    override func scrapeData() {
        super.scrapeData()
        
        // Use library elements if nothing in search box
        if searchText.isEmpty {
            self.filteredcards.append(contentsOf: (vcDelegate?.getLibrary())!)
            tableViewCont.reloadData()
        }
    }
}
