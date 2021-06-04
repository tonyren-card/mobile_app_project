//
//  ViewController.swift
//  Project
//
//  Created by Tony Ren on 2020-07-02.
//  Copyright © 2020 TonyRen. All rights reserved.
//

import UIKit
//import UIKit.CreateUserVC

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
//    @IBOutlet var addBarButton
    
    @IBOutlet var msCarName: UIButton!
    @IBOutlet var msCarImg: UIImageView!
    
//    var addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCar))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.rightBarButtonItem = addBarButton
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sampleCar")
        
//        let btnListCar = cell?.contentView.viewWithTag(1) as! UIButton
//        
//        let imgListCar = cell?.contentView.viewWithTag(2) as! UIImage
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "cardCivic", sender: self)
        
        print("Tapped Card")
    }
    
//    @IBAction func addCar() {
//        let storyboard = UIStoryboard(name: "AddNewCar", bundle: nil)
//        let secondVC = storyboard.instantiateViewController(identifier: "createCard")
//
//        show(secondVC, sender: self)
//    }
    
    @IBAction func competitorTapped(sender: UIButton) {
        
    }


}
