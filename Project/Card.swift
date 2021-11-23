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

struct APIResponse: Codable {
    let images_results: [Result]
}

struct Result: Codable{
    let original: String
}

//Card object defining variables for Realm storage

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
    var added: Bool = false
    var hasLoadedAPI: Bool = false
    var hasLoadedImage: Bool = false
    
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
        self.carImgSpinner?.hidesWhenStopped = true
        self.carImgSpinner?.startAnimating()
        setDisplayText()
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.hasLoadedAPI && self.carImg?.image==nil{
            loadImageView()
        }
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
            
//        self.carImg?.image = UIImage(named: self.carImgPath)
        
        loadAPIImageLink()
//        loadImageView()
//        print("Loading from setDisplayText(): \(self.carImgPath)")
        
//        self.carImg?.load(url: URL(string: self.carImgPath)!)
        
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
    
    func loadAPIImageLink(){
        if self.hasLoadedAPI {
            return
        }
        
        print("Loading API...")
        let carNameStrip = self.carNameStr.replacingOccurrences(of: " ", with: "+")
        print(carNameStrip)
        let apiString = "https:serpapi.com/search.json?q=\(carNameStrip)&tbm=isch&ijn=0&api_key=8aa8f4d59b7bead3ea8e23f2a1b321ceff9e0e4d2678d33107ca876e632638e0"
        
        guard let api = URL(string: apiString) else{
            print("API failed!")
            return
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
                    self?.carImgPath = jsonResult.images_results[0].original
                    print(self!.carImgPath)
                    self?.hasLoadedAPI = true
                    if self?.carImg?.image == nil {
                        print("Presenting")
                        self?.loadImageView()
                    } else {
                        print("Image not empty")
                    }
                }
            } catch  {
                print(error)
            }
        }.resume()
        
        
    }
    
    func loadImageView(){
        print("Loading image...")
        guard let url = URL(string: self.carImgPath) else {
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
                self?.hasLoadedImage = true
                self?.carImgSpinner?.stopAnimating()
            }
        }.resume()
    }

}
