//
//  ViewCompare.swift
//  iosCard
//
//  Created by Tony Ren on 2021-12-06.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit
import SwiftUI

protocol QueryDelegate{
    func setCard(for index: CChar, card: Card)
}

class ViewCompare: UIViewController, QueryDelegate {
    var card = [Card?](repeating: nil, count: 2)
    
    var addIndex: CChar? = -1
    
    @IBOutlet var carName: [UILabel]!
    @IBOutlet var price: [UILabel]!
    @IBOutlet var engine: [UILabel]!
    @IBOutlet var horsepower: [UILabel]!
    @IBOutlet var wheelbase: [UILabel]!
    @IBOutlet var efficiency: [UILabel]!
    @IBOutlet var capacity: [UILabel]!
    @IBOutlet var sales: [UILabel]!
    @IBOutlet var addBtn: [UIButton]!
    @IBOutlet var removeBtn: [UIButton]!
    @IBOutlet var carImage: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSpecsHidden(to: true, index: 0)
        setSpecsHidden(to: true, index: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vcs = segue.destination as? ViewCompareSearch{
            let firstTabController = tabBarController!.viewControllers![0] as! UINavigationController
            vcs.vcDelegate = firstTabController.viewControllers.first as? CompareDelegate
            vcs.compDelegate = self
            vcs.addQuery = self.addIndex
        }
    }
    
    func setSpecsHidden(to val: Bool, index: Int){
        self.carImage[index].image = nil
        self.carImage[index].isHidden = val
        self.price[index].isHidden = val
        self.engine[index].isHidden = val
        self.horsepower[index].isHidden = val
        self.wheelbase[index].isHidden = val
        self.efficiency[index].isHidden = val
        self.capacity[index].isHidden = val
        self.sales[index].isHidden = val
        
        self.addBtn[index].isHidden = !val
        self.removeBtn[index].isHidden = val
    }
    
    func setCard(for index: CChar, card: Card){
        let indexInt = Int(index)
        self.card[indexInt] = card
        setSpecsHidden(to: false, index: indexInt)
        
        self.carName[indexInt].text = self.card[indexInt]?.getCarName()
        self.price[indexInt].text = self.card[indexInt]?.getPrice()
        self.engine[indexInt].text = self.card[indexInt]?.getEngineSize()
        self.horsepower[indexInt].text = self.card[indexInt]?.getHorsePower()
        self.wheelbase[indexInt].text = self.card[indexInt]?.getWheelBase()
        self.efficiency[indexInt].text = self.card[indexInt]?.getFuelEff()
        self.capacity[indexInt].text = self.card[indexInt]?.getFuelCap()
        self.sales[indexInt].text = self.card[indexInt]?.getSales()
        
        self.carImage[indexInt].load(url: (self.card[indexInt]?.getImgPath()) ?? " car")
        
        if (self.card[0] != nil && self.card[1] != nil) {
            setAdvantages()
        }
    }
    
    func setAdvantages(){
        let price1 = priceToFloat(price[0].text!)
        let price2 = priceToFloat(price[1].text!)
        if (price1 < price2) { setHighlight(for: price[0])}
        else if (price2 < price1) { setHighlight(for: price[1])}
        
        let eng1 = Float(engine[0].text!)!
        let eng2 = Float(engine[1].text!)!
        if (eng1 > eng2) { setHighlight(for: engine[0])}
        else if (eng2 > eng1) { setHighlight(for: engine[1])}
        
        let hp1 = Int(horsepower[0].text!)!
        let hp2 = Int(horsepower[1].text!)!
        if (hp1 > hp2) { setHighlight(for: horsepower[0])}
        if (hp2 > hp1) { setHighlight(for: horsepower[1])}
        
        let wb1 = Float(wheelbase[0].text!)!
        let wb2 = Float(wheelbase[1].text!)!
        if (wb1 > wb2) { setHighlight(for: wheelbase[0])}
        if (wb2 > wb1) { setHighlight(for: wheelbase[1])}
        
        let fe1 = effToInt(efficiency[0].text!)
        let fe2 = effToInt(efficiency[1].text!)
        if (fe1 > fe2) { setHighlight(for: efficiency[0])}
        if (fe2 > fe1) { setHighlight(for: efficiency[1])}
        
        let fc1 = Float(capacity[0].text!)!
        let fc2 = Float(capacity[1].text!)!
        if (fc1 > fc2) { setHighlight(for: capacity[0])}
        if (fc2 > fc1) { setHighlight(for: capacity[1])}

        let sale1 = salesToInt(sales[0].text!)
        let sale2 = salesToInt(sales[1].text!)
        if (sale1 > sale2) { setHighlight(for: sales[0])}
        if (sale2 > sale1) { setHighlight(for: sales[1])}
    }
    
    func setHighlight(for label: UILabel){
        label.textColor = .systemGreen
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
    }
    
    func clearHighlights(){
        for i in 0..<2 {
            clearHighlight(for: price[i])
            clearHighlight(for: engine[i])
            clearHighlight(for: horsepower[i])
            clearHighlight(for: wheelbase[i])
            clearHighlight(for: efficiency[i])
            clearHighlight(for: capacity[i])
            clearHighlight(for: sales[i])
        }
    }
    
    private func clearHighlight(for label: UILabel){
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: label.font.pointSize)
    }
    
    private func priceToFloat(_ el: String) -> Float{
        var str = el
        if let i = str.firstIndex(of: "$"){
            str.remove(at: i)
        }
        
        return Float(str)!
    }
    
    private func effToInt(_ el: String) -> Int {
        var str = el
        if let i = str.firstIndex(of: " "){
            str.removeSubrange(i...)
        }
        
        return Int(str)!
    }
    
    private func salesToInt(_ el: String) -> Int {
        return effToInt(el)
    }
    
    
    @IBAction func addCar1(_ sender: Any) {
        // Assign the add query before segue
        addIndex = 0
    }
    
    @IBAction func addCar2(_ sender: Any) {
        addIndex = 1
    }
    
    @IBAction func removeCar1(_ sender: Any) {
        clearHighlights()
        setSpecsHidden(to: true, index: 0)
        card[0] = nil
        carName[0].text = "Car 1"
    }
    
    @IBAction func removeCar2(_ sender: Any) {
        clearHighlights()
        setSpecsHidden(to: true, index: 1)
        card[1] = nil
        carName[1].text = "Car 2"
    }
}
