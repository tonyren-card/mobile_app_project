//
//  ViewController.swift
//  Project
//
//  Created by Tony Ren on 2020-07-02.
//  Copyright © 2020 TonyRen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets for the Honda Civic Sample Card
    @IBOutlet var tableView: UITableView!
    @IBOutlet var msCarName: UIButton!
    @IBOutlet var msCarImg: UIImageView!
    
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sampleCar")
        
        return cell!
    }
    
    //When a cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "cardCivic", sender: self)
        
        print("Tapped Card")
    }
    
    @IBAction func competitorTapped(sender: UIButton) {
        
    }
    
    func addCard(cardObject card: Card){
        cards.append(card)
    }


}
