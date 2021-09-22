//
//  ViewController.swift
//  Project
//
//  Created by Tony Ren on 2020-07-02.
//  Copyright © 2020 TonyRen. All rights reserved.
//

import UIKit

protocol CardDelegate {
    func addCard(cardObject: Card)
}

class ViewController: UIViewController, CardDelegate {
    
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
    
    @IBAction func addBtnAction(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewSearch{
            vc.mainController = self
        }
    }
    
    func addCard(cardObject: Card){
        print("Conforming")
        print("Adding card object from VC: \(cardObject.getCarName())")
        cards.append(cardObject)
        print("Cards array size = \(cards.count)")
    }

}

extension ViewController: UITableViewDelegate{
    //When a cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "cardCivic", sender: self)
        
        print("Tapped Card")
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sampleCar")
        tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        
        return cell!
    }
}
