//
//  Card.swift
//  iosCard
//
//  "CARD" object that consists variables which are its specifics
//
//  Created by Tony Ren on 2021-06-14.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import RealmSwift
import UIKit

struct APIResponse: Codable {
    let images_results: [Result]
}

struct Result: Codable{
    let original: String
}

//Card object defining variables for Realm storage (requires installation)
class CardObject: Object {
    //Definition of the variables
    @objc dynamic var carMakeStr: String = " " //New
    @objc dynamic var carModelStr: String = " " //New
    @objc dynamic var carNameStr: String = " "
    @objc dynamic var salesStr: String = " "
    @objc dynamic var carTypeStr: String = " "
    @objc dynamic var priceStr: String = " "
    @objc dynamic var horsepowerStr: String = " "
    @objc dynamic var engineSizeStr: String = " "
    @objc dynamic var wheelbaseStr: String = " "
    @objc dynamic var fuelEffStr: String = " "
    @objc dynamic var fuelCapStr: String = " "
    @objc dynamic var latestLaunchStr: String = " "
    @objc dynamic var carImgPath: String = " "
    @objc dynamic var index: Int = -1
    @objc dynamic var added: Bool = false
    @objc dynamic var hasLoadedAPI: Bool = false
    @objc dynamic var hasLoadedImage: Bool = false
}

class Card: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    
    private var cardObj: CardObject? = nil
    
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
    @IBOutlet weak var carImgSpinner: UIActivityIndicatorView?
    
    @IBOutlet weak var addCarBtn: UIButton?
    
    var delegate: CardDelegate?
    
    override func viewDidLoad() {
        setDisplayText()
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self.getCarName()), index \(self.cardObj!.index)")
        if self.cardObj!.hasLoadedAPI && self.carImg?.image==nil{
            loadImageView()
        }
    }
    
    //Constructor of the object
    init(carMake make: String, carModel model: String, carSales sales: String, carType type: String, carPrice price: String, carHP horsepower: String, carEngine engineSize: String, carWB wheelbase: String, carFuel fuelEff: String, carCap fuelCap: String, carLaunch latestLaunch: String){
        
        super.init(nibName: nil, bundle: nil)
        
        self.cardObj = CardObject()
        
        self.cardObj!.carMakeStr = make
        self.cardObj!.carModelStr = model
        self.cardObj!.carNameStr = "\(make) \(model)"
        self.cardObj!.salesStr = sales
        self.cardObj!.carTypeStr = type
        self.cardObj!.priceStr = price
        self.cardObj!.horsepowerStr = horsepower
        self.cardObj!.engineSizeStr = engineSize
        self.cardObj!.wheelbaseStr = wheelbase
        self.cardObj!.fuelEffStr = fuelEff
        self.cardObj!.fuelCapStr = fuelCap
        self.cardObj!.latestLaunchStr = latestLaunch
    }
    
    //Constructor for existing card objects (copy ctor)
    init(cardObj: CardObject, delegate: CardDelegate){
        super.init(nibName: nil, bundle: nil)
        self.cardObj = cardObj
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getCarModel() -> String{
        return self.cardObj!.carModelStr
    }
    
    func getCarName() -> String{
        return self.cardObj!.carNameStr
    }
    
    func getSales() -> String {
        return self.cardObj!.salesStr
    }
    
    func getSalesFloat() -> Float {
        let sales = self.cardObj!.salesStr
        let output = Float(sales.replacingOccurrences(of: " units", with: ""))
        if (output == nil) { return -1.0 }
        
//        let endIndex = eff.firstIndex(of: " ")!
//        print(eff)
//        print("getfueleffFloat(): \(output)")
        
        return output!
    }
    
    func getPrice() -> String {
        return self.cardObj!.priceStr
    }
    
    func getPriceFloat() -> Float {
        let price = self.cardObj!.priceStr
        if (price.isEmpty) { return -1.0 }
        
        let index = price.index(price.startIndex, offsetBy: 1)
        
        return Float(price[index...])!
    }
    
    func getHorsePower() -> String {
        return self.cardObj!.horsepowerStr
    }
    
    func getHorsePowerFloat() -> Float {
        return Float(self.cardObj!.horsepowerStr)!
    }
    
    func getEngineSize() -> String {
        return self.cardObj!.engineSizeStr
    }
    
    func getEngineSizeFloat() -> Float {
        return Float(self.cardObj!.engineSizeStr)!
    }
    
    func getWheelBase() -> String {
        return self.cardObj!.wheelbaseStr
    }
    
    func getWheelBaseFloat() -> Float {
        return Float(self.cardObj!.wheelbaseStr)!
    }
    
    func getFuelEff() -> String {
        return self.cardObj!.fuelEffStr
    }
    
    func getFuelEffFloat() -> Float {
        let eff = self.cardObj!.fuelEffStr
        let output = Float(eff.replacingOccurrences(of: " mpg", with: ""))
        if (output == nil) { return -1.0 }
        
//        let endIndex = eff.firstIndex(of: " ")!
//        print(eff)
//        print("getfueleffFloat(): \(output)")
        
        return output!
    }
    
    func getFuelCap() -> String {
        return self.cardObj!.fuelCapStr
    }
    
    func getFuelCapFloat() -> Float {
        return Float(self.cardObj!.fuelCapStr)!
    }
    
    func getLatestLaunch() -> String {
        return self.cardObj!.latestLaunchStr
    }
    
    func getImgPath() -> String{
        return self.cardObj!.carImgPath
    }
    
    func setIndex(to val: Int) {
        try! Realm().write{
            self.cardObj!.index = val
        }
    }
    
    func isAdded() -> Bool {
        return self.cardObj!.added
    }
    
    func setAdded(to val: Bool) {
        self.cardObj!.added = val
    }
    
    func hasLoadedAPI() -> Bool {
        return self.cardObj!.hasLoadedAPI
    }
    
    func getCardObj() -> CardObject{
        return self.cardObj!
    }
    
    func setDisplayText(){
        self.carName?.text = self.cardObj!.carNameStr
        self.sales?.text = self.cardObj!.salesStr
        self.carType?.text = self.cardObj!.carTypeStr
        self.price?.text = self.cardObj!.priceStr
        self.horsepower?.text = self.cardObj!.horsepowerStr
        self.engineSize?.text = self.cardObj!.engineSizeStr
        self.wheelbase?.text = self.cardObj!.wheelbaseStr
        self.fuelEff?.text = self.cardObj!.fuelEffStr
        self.fuelCap?.text = self.cardObj!.fuelCapStr
        self.latestLaunch?.text = self.cardObj!.latestLaunchStr
        
        loadAPIImageLink()
    }
    
    func updateAddDelButton(){
        self.addCarBtn?.setTitle(self.cardObj!.added ? "Delete from Library" : "Add to Library", for: .normal)
        self.addCarBtn?.setTitleColor(self.cardObj!.added ? .systemRed : .systemBlue, for: .normal)
    }
    
    @IBAction func addCard(_ sender: Any) {
        if !self.cardObj!.added{
            delegate?.addCard(cardObject: self)
            updateAddDelButton()
        }else{
            dismiss(animated: true, completion: {
                self.delegate?.deleteCard(at: self.cardObj!.index)
            })
        }
    }
    
    @IBAction func compare(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.segueCompare(card: self)
        })
    }
    
    func loadAPIImageLink() -> Bool{
        if self.cardObj!.hasLoadedAPI {
            return true
        }
        
        print("Loading API...")
        let carNameStrip = self.cardObj!.carNameStr.replacingOccurrences(of: " ", with: "+")
        print(carNameStrip)
        let apiString = "https:serpapi.com/search.json?q=\(carNameStrip)&tbm=isch&ijn=0&api_key=8aa8f4d59b7bead3ea8e23f2a1b321ceff9e0e4d2678d33107ca876e632638e0"
        
        guard let api = URL(string: apiString) else{
            print("API failed!")
            return false
        }
        
        URLSession.shared.dataTask(with: api){ [weak self] data, _, error in
            guard let data = data, error == nil else{
                print("api failed!")
                return
            }
            
            print("Found API!")
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    try! Realm().write{
                        self?.cardObj!.carImgPath = jsonResult.images_results[0].original
                        print(self!.cardObj!.carImgPath)
                        self?.cardObj!.hasLoadedAPI = true
                    }
                    if self?.carImg?.image == nil {
                        print("Presenting")
                        self?.loadImageView()
                    } else {
                        print("Image not empty")
                    }
                }
            } catch  {
                print(error)
                return
            }
        }.resume()
        
        return self.cardObj!.hasLoadedAPI
    }
    
    func loadImageView(){
        print("Loading image...")
        guard let url = URL(string: self.cardObj!.carImgPath) else {
            print("Image url failed")
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("Image load failure")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.carImg?.image = image
                print("Image loaded!")
                try! Realm().write {
                    self?.cardObj!.hasLoadedImage = true
                }
                self?.carImgSpinner?.stopAnimating()
            }
        }.resume()
    }

}

extension Card: Comparable{
    static func < (lhs: Card, rhs: Card) -> Bool{
        return lhs.cardObj!.index < rhs.cardObj!.index
    }
    static func == (lhs: Card, rhs: Card) -> Bool{
        return lhs.cardObj!.index == rhs.cardObj!.index
    }
    static func > (lhs: Card, rhs: Card) -> Bool{
        return lhs.cardObj!.index > rhs.cardObj!.index
    }
}
