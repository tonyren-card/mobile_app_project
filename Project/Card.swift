//
//  Card.swift
//  Project
//
//  "CARD" object that consists variables which are its specifics
//
//  Created by Tony Ren on 2021-06-14.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class Card: UIViewController {
    
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var sales: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var horsepower: UILabel!
    @IBOutlet weak var engineSize: UILabel!
    @IBOutlet weak var wheelbase: UILabel!
    @IBOutlet weak var fuelEff: UILabel!
    @IBOutlet weak var fuelCap: UILabel!
    @IBOutlet weak var latestLaunch: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    init(carName name: String, carSales sales: String, carType type: String){
        self.carName.text = name
        self.sales.text = sales
        self.carType.text = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCarName() -> String{
        return carName.text ?? " "
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
