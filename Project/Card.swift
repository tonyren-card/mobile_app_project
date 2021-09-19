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
    var carNameStr: String = " "
    var salesStr: String = " "
    var carTypeStr: String = " "
    var priceStr: String = " "
    var horsepowerStr: String = " "
    var engineSizeStr: String = " "
    var wheelbaseStr: String = " "
    var fuelEffStr: String = " "
    var fuelCapStr: String = " "
    var latestLaunchStr: String = " "
    
    //Definition of the labels
    @IBOutlet weak var carName: UILabel?
    @IBOutlet weak var sales: UILabel?
    @IBOutlet weak var carType: UILabel?
    @IBOutlet weak var price: UILabel?
    @IBOutlet weak var horsepower: UILabel?
    @IBOutlet weak var engineSize: UILabel?
    @IBOutlet weak var wheelbase: UILabel?
    @IBOutlet weak var fuelEff: UILabel?
    @IBOutlet weak var fuelCap: UILabel?
    @IBOutlet weak var latestLaunch: UILabel?
    
    @IBOutlet weak var addCarBtn: UIButton!
    
    var delegate: CardDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.carNameStr = "Car not found"
        self.carTypeStr = "There may be a typo in your search"
        
        print("From Card object: \(getCarName())")
//        commonInit()
    }
    
    //Constructor of the object
    init(carName name: String, carSales sales: String, carType type: String, carPrice price: String, carHP horsepower: String, carEngine engineSize: String, carWB wheelbase: String, carFuel fuelEff: String, carCap fuelCap: String, carLaunch latestLaunch: String){
        
        super.init(nibName: nil, bundle: nil)
        
        self.carNameStr = name
        self.salesStr = sales
        self.carTypeStr = type
        self.priceStr = price
        self.horsepowerStr = horsepower
        self.engineSizeStr = engineSize
        self.wheelbaseStr = wheelbase
        self.fuelEffStr = fuelEff
        self.fuelCapStr = fuelCap
        self.latestLaunchStr = latestLaunch
        
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
    
    func setDisplayText(){
        self.carName?.text = self.carNameStr
        self.sales?.text = self.salesStr
        self.carType?.text = self.carTypeStr
        self.price?.text = self.priceStr
        self.horsepower?.text = self.horsepowerStr
        self.engineSize?.text = self.engineSizeStr
        self.wheelbase?.text = self.wheelbaseStr
        self.fuelEff?.text = self.fuelEffStr
        self.fuelCap?.text = self.fuelCapStr
        self.latestLaunch?.text = self.latestLaunchStr
        
        if self.carName?.text == "Car not found" {
            addCarBtn.removeFromSuperview()
        }
    }
    
    @IBAction func addCard(_ sender: Any) {
        
        if self.addCarBtn.titleLabel?.text == "Add Card to Library"{
            print("Add card pressed")
            self.addCarBtn.setTitle("Card added to Library", for: .normal)
            delegate?.addCard(cardObject: self)
            print("Passed delegate point")
        }
    }
    

}
