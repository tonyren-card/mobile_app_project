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
    func deleteCard(at index: Int)
    func getCard(equals car: String) -> Card?
}

class ViewController: UIViewController, CardDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CARD"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //for first time users displaying welcome screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        let hasViewedWelcome = defaults.bool(forKey: "hasViewedWelcome")
        if hasViewedWelcome { return }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WelcomeController") as? WelcomePageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewSearch{
            vc.mainController = self
        }
    }
    
    func addCard(cardObject: Card){
        cardObject.added = true
        cardObject.index = cards.count
        cards.append(cardObject)
        
        //update table view to add cell
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: cards.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func deleteCard(at index: Int){
        cards.remove(at: index)
        updateCardsIndices(at: index)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func getCard(equals car: String) -> Card?{
        for card in cards {
            if (card.getCarName() == car){
                return card
            }
        }
        
        return nil
    }
    
    private func updateCardsIndices(at index: Int){
        if index > cards.count-1 {
            return
        }
        for i in index...cards.count-1{
            cards[i].index = i
        }
    }

}

extension ViewController: UITableViewDelegate{
    //When a cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dispCardAct(indexPath.row)
    }
    
    func dispCardAct(_ x: Int){
        //Dismiss
        self.dismiss(animated: false, completion: {
            //Segue
            self.present(self.cards[x], animated: true)
            //Display
            if !self.cards[x].visited {
                self.cards[x].visited = true
                self.cards[x].setDisplayText()
            }
            self.cards[x].updateAddDelButton()
        })
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        
        let cellLblCar = cell.contentView.viewWithTag(11) as! UILabel
        cellLblCar.text = "\(cards[indexPath.row].getCarName())"
        
        let cellImgCar = cell.contentView.viewWithTag(12) as! UIImageView
        cellImgCar.image = UIImage(named: cards[indexPath.row].getImgPath())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCell.EditingStyle.delete {
            cards[indexPath.row].added = false
            cards.remove(at: indexPath.row)
            updateCardsIndices(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}
