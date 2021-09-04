//
//  Scrape.swift
//  Project
//
//  Created by Tony Ren on 2021-03-07.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class Scrape: UIViewController {
    var searchCar: String = ""
    
    var scrapeCard: Card? = nil
    
    //Definition of the variables
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
        print("Searching: \(self.searchCar)")
        self.scrapeData()
    }
    
    func scrapeData(){
        //CSV file opens
        let file = "Car_sales"
        
        guard let filepath = Bundle.main.path(forResource: file, ofType: "csv")
        else{
            print("error occured opening file \(file)")
            return
        }

        //Reading and processing CSV file
        do {
            let contents = try String(contentsOfFile: filepath)
            
            //            var counter = 0
            //            for line in lines{
            //                if counter == 0{
            //                    counter += 1
            //                    continue
            //                }
            //                print("\(line) at index \(counter)")
            //                counter += 1
            //            }
            //            let line = contents.components(separatedBy: ",")
            //            print("line = \(line)")
            //            let blockIndex = line.firstIndex(of: "Integra") ?? 0
            //            let block = line[blockIndex]
            //            print("block = \(String(block)) at \(blockIndex)")
            
            let lines = contents.components(separatedBy: "\n")
//            let searchKeys = self.searchCar.components(separatedBy: " ")
            var firstLine = true
            
            var foundCarInfo: [String]? = nil
            
            //Data gets collected
            for line in lines{
                if firstLine{
                    firstLine = false
                    continue
                }
                let blocks = line.components(separatedBy: ",")
                let lineSpaced = blocks.joined(separator: " ")
                
                if (lineSpaced.range(of: self.searchCar, options: .caseInsensitive) != nil){
                    print(line)
                    foundCarInfo = blocks
                    break
                }
                
//                let hasCar = lineSpaced.contains {
//                    if case self.searchCar {
//                        return true
//                    } else {
//                        return false
//                    }
//                }
            }
            
            //If no car found
            guard let checkString = foundCarInfo, !checkString.isEmpty else{
//                viewCardObject()
                self.scrapeCard = Card()
//                self.present(self.scrapeCard!, animated: true)
                return
            }
            
            //Data gets presented
            var sales = ""
            if let floatSales = Float(String((foundCarInfo?[2])!)){
                sales = String(format: "%.0f units", floatSales*1000)
            }else{
                sales = String((foundCarInfo?[2])!)
            }
            
            var price = ""
            if let floatPrice = Float(String((foundCarInfo?[5])!)){
                price = String(format: "$%.2f", floatPrice*1000)
            }else{
                price = String((foundCarInfo?[5])!)
            }
            
            self.scrapeCard = Card(carName: "\(String((foundCarInfo?[0])!)) \(String((foundCarInfo?[1])!))", carSales: sales, carType: String((foundCarInfo?[4])!), carPrice: price, carHP: String((foundCarInfo?[7])!), carEngine: String((foundCarInfo?[6])!), carWB: String((foundCarInfo?[8])!), carFuel: "\(String((foundCarInfo?[13])!)) mpg", carCap: String((foundCarInfo?[12])!), carLaunch: String((foundCarInfo?[14])!))
//            self.present(self.scrapeCard!, animated: true)
            
            /*self.carName.text = "\(String((foundCarInfo?[0])!)) \(String((foundCarInfo?[1])!))"
            
            if let floatSales = Float(String((foundCarInfo?[2])!)){
                self.sales.text = String(format: "%.0f units", floatSales*1000)
            }else{
                self.sales.text = String((foundCarInfo?[2])!)
            }
            
            self.carType.text = String((foundCarInfo?[4])!)
            
            if let floatPrice = Float(String((foundCarInfo?[5])!)){
                self.price.text = String(format: "$%.2f", floatPrice*1000)
            }else{
                self.price.text = String((foundCarInfo?[5])!)
            }
            
            self.engineSize.text = String((foundCarInfo?[6])!)
            self.horsepower.text = String((foundCarInfo?[7])!)
            self.wheelbase.text = String((foundCarInfo?[8])!)
            self.fuelCap.text = String((foundCarInfo?[12])!)
            self.fuelEff.text = "\(String((foundCarInfo?[13])!)) mpg"
            self.latestLaunch.text = String((foundCarInfo?[14])!)*/
        }catch{
            print("File read error for file \(filepath)")
        }
    }
    
    private func viewCardObject(){
//        self.scrapeCard = Card()
    }
    
    @IBAction private func navigationButtonTapped(_ sender: Any) {
        print("viewing card object...")
        self.present(self.scrapeCard!, animated: true)
        print("performing segue to card")
    }

}
