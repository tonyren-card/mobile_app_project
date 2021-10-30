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
    private var carNameStr: String = " "
    private var salesStr: String = " "
    private var carTypeStr: String = " "
    private var priceStr: String = " "
    private var horsepowerStr: String = " "
    private var engineSizeStr: String = " "
    private var wheelbaseStr: String = " "
    private var fuelEffStr: String = " "
    private var fuelCapStr: String = " "
    private var latestLaunchStr: String = " "
    private var carImgPath: String = " "
    var index: Int? = -1
    var visited: Bool = false
    var added: Bool = false
    
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
    @IBOutlet weak var carImg: UIImageView?
    
    @IBOutlet weak var addCarBtn: UIButton?
    
    var delegate: CardDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.carNameStr = "Car not found"
        self.carTypeStr = "There may be a typo in your search"
    }
    
    //Constructor of the object
    init(carName name: String, carSales sales: String, carType type: String, carPrice price: String, carHP horsepower: String, carEngine engineSize: String, carWB wheelbase: String, carFuel fuelEff: String, carCap fuelCap: String, carLaunch latestLaunch: String, carImg imgPath: String){
        
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
        self.carImgPath = String(imgPath.filter { !"\r".contains($0) })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getCarName() -> String{
        return carNameStr
    }
    
    func getImgPath() -> String{
        return carImgPath
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
        
        if (self.carImgPath == ""){
            self.carImgPath = "ordinary_car.png"
        }
            
        self.carImg?.image = UIImage(named: self.carImgPath)
        
        if self.carName?.text == "Car not found" {
            addCarBtn?.removeFromSuperview()
        }
    }
    
    func updateAddDelButton(){
        self.addCarBtn?.setTitle(self.added ? "Delete Card from Library" : "Add Card to Library", for: .normal)
    }
    
    @IBAction func addCard(_ sender: Any) {
        
        if !self.added{
            delegate?.addCard(cardObject: self)
        }else{
            self.added = false
            delegate?.deleteCard(at: self.index!)
        }
        updateAddDelButton()
    }
    

}
