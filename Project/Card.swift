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
    var carNameStr: String = " "
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
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.carNameStr = "Car not found"
        self.carName?.text = self.carNameStr
        self.carType?.text = "There may be a typo in your search"
        
        print(getCarName())
    }
    
    init(carName name: String, carSales sales: String, carType type: String, carPrice price: String, carHP horsepower: String, carEngine engineSize: String, carWB wheelbase: String, carFuel fuelEff: String, carCap fuelCap: String, carLaunch latestLaunch: String){
        super.init(nibName: nil, bundle: nil)
        
        self.carNameStr = name
        self.carName?.text = self.carNameStr
        self.sales?.text = sales
        self.carType?.text = type
        self.price?.text = price
        self.horsepower?.text = horsepower
        self.engineSize?.text = engineSize
        self.wheelbase?.text = wheelbase
        self.fuelEff?.text = fuelEff
        self.fuelCap?.text = fuelCap
        self.latestLaunch?.text = latestLaunch
        
        print("card object created: \(getCarName())")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCarName() -> String{
        return carNameStr
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
