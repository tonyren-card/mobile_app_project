//
//  ViewController.swift
//  iosCard
//
//  Created by Tony Ren on 2020-07-02.
//  Copyright © 2020 TonyRen. All rights reserved.
//

import RealmSwift
import UIKit

protocol CardDelegate {
    func addCard(cardObject: Card)
    func deleteCard(at index: Int)
    func getCard(equals car: String) -> Card?
    func reloadTableView()
    func segueCompare(card: Card)
}

protocol CompareDelegate {
    func getLibrary() -> [Card]
    func getLibrarySize() -> Int
}

class ViewController: UIViewController, CardDelegate, CompareDelegate {
    
    var queryDelegate: QueryDelegate?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var cards: [Card] = []
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.queryDelegate = tabBarController!.viewControllers![1] as? QueryDelegate
        render()
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        
        if (!editing){
            updateCardsIndices(at: 0)
            realm.refresh()
        }
    }
    
    func render() {
        let cards = realm.objects(CardObject.self)
        
        tableView.beginUpdates()
        for card in cards {
            print("\(card.index). \(card.carNameStr)")
            self.cards.append(Card(cardObj: card, delegate: self))
            tableView.insertRows(at: [IndexPath(row: self.cards.count-1, section: 0)], with: .automatic)
        }
        self.cards.sort()
        tableView.endUpdates()
        
//        try! realm.write{
//            realm.deleteAll()
//        }
    }
    
    func addCard(cardObject: Card){
        cardObject.setAdded(to: true)
        cardObject.setIndex(to: cards.count)
        cards.append(cardObject)
        
        //update table view to add cell
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: cards.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
        
        //add to realm
        realm.beginWrite()
        realm.add(cardObject.getCardObj())
        try! realm.commitWrite()
    }
    
    func deleteCard(at index: Int){
        //update realm
        realm.beginWrite()
            cards[index].setAdded(to: false)
            let delete: [CardObject] = [cards[index].getCardObj()]
            realm.delete(delete)
        try! realm.commitWrite()
        
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
    
    func segueCompare(card: Card){
        tabBarController?.selectedIndex = 1
        queryDelegate?.setCard(card: card)
    }
    
    func getLibrary() -> [Card]{
        return self.cards
    }
    
    func getLibrarySize() -> Int {
        return self.cards.count
    }

    func reloadTableView(){
        self.tableView.reloadData()
    }
    
    private func updateCardsIndices(at index: Int){
        if index > cards.count-1 {
            return
        }
        for i in index...cards.count-1{
            cards[i].setIndex(to: i)
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
        
//        let cellImgSpin = cell.contentView.viewWithTag(13) as! UIActivityIndicatorView
//        cellImgSpin.hidesWhenStopped = true
        
        let cellImgCar = cell.contentView.viewWithTag(12) as! UIImageView
        cellImgCar.load(url: cards[indexPath.row].getImgPath())
        
//        if (cellImgCar.image == nil){
//            cellImgSpin.startAnimating()
//        }else{
//            cellImgSpin.stopAnimating()
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.cards.remove(at: sourceIndexPath.row)
        self.cards.insert(item, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCell.EditingStyle.delete {
            deleteCard(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Compare")
        { [weak self] (action, view, completionHandler) in
            self?.segueCompare(card: (self?.cards[indexPath.row])!)
            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension UIImageView {
    func load(url path: String) {
        guard let url = URL(string: path) else {
            print("image not loaded")
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("image load fail")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.image = image
                print("image loaded by UI")
            }
        }.resume()
    }
}
