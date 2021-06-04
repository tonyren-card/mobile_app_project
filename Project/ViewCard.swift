//
//  ViewCard.swift
//  Project
//
//  Created by Tony Ren on 2020-12-31.
//  Copyright © 2020 TonyRen. All rights reserved.
//

import UIKit

class ViewCard: UIViewController {

    @IBOutlet weak var lblCar: UILabel!
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var startPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var powertrain: UILabel!
    @IBOutlet var engines: [UILabel]!
    @IBOutlet weak var trims: UILabel!
    @IBOutlet var listTrims: [UILabel]!
    @IBOutlet weak var assembly: UILabel!
    @IBOutlet weak var locAssembly: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var competitors: UILabel!
    @IBOutlet var listCompetitors: [UIButton]!
    
    var searchCar: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let send = segue.destination as? Scrape{
            send.searchCar = self.searchCar ?? "Rand"
        }
    }
    
    @IBAction func competitorTapped(_ sender: UIButton!){
        
        self.searchCar = sender.titleLabel?.text ?? "  "
        print("Tapped \(self.searchCar ?? " ")")
        
        performSegue(withIdentifier: "scrapeFromButton", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
