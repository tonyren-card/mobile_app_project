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
    
    @IBOutlet weak var cardView: UIView!
    //Definition of the variables
    @IBOutlet weak var carName: UILabel?
    var carNameStr: String = " "
    @IBOutlet weak var sales: UILabel?
    @IBOutlet weak var carType: UILabel?
    @IBOutlet weak var price: UILabel?
    @IBOutlet weak var horsepower: UILabel?
    @IBOutlet weak var engineSize: UILabel?
    @IBOutlet weak var wheelbase: UILabel?
    @IBOutlet weak var fuelEff: UILabel?
    @IBOutlet weak var fuelCap: UILabel?
    @IBOutlet weak var latestLaunch: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
//        commonInit()
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.carNameStr = "Car not found"
        self.carName?.text = "Car not found"
        self.carType?.text = "There may be a typo in your search"
        
        print("From Card object: \(getCarName())")
//        commonInit()
    }
    
    //Constructor of the object
    init(carName name: String, carSales sales: String, carType type: String, carPrice price: String, carHP horsepower: String, carEngine engineSize: String, carWB wheelbase: String, carFuel fuelEff: String, carCap fuelCap: String, carLaunch latestLaunch: String){
        
        super.init(nibName: nil, bundle: nil)
        
        self.carNameStr = name
        self.carName?.text = name
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
//        commonInit()
//        print(self.carName.text ?? "variable not assigned")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Card", owner: self, options: nil)
//        addSubview(cardView)
//        cardView.frame = self.bounds
//        cardView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func getCarName() -> String{
        return carNameStr
    }

}
