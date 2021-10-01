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
}

class ViewController: UIViewController, CardDelegate {
    
    //Outlets for the Honda Civic Sample Card
    @IBOutlet var tableView: UITableView!
    @IBOutlet var msCarImg: UIImageView!
    
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewSearch{
            vc.mainController = self
        }
    }
    
    func addCard(cardObject: Card){
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
            cards.remove(at: indexPath.row)
            updateCardsIndices(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}
