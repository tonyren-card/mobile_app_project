//
//  ViewCompare.swift
//  iosCard
//
//  Created by Tony Ren on 2021-12-06.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

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

        setSpecsHidden(to: true, for: 0)
        setSpecsHidden(to: true, for: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vcs = segue.destination as? ViewCompareSearch{
            let firstTabController = tabBarController!.viewControllers![0] as! UINavigationController
            vcs.vcDelegate = firstTabController.viewControllers.first as? CompareDelegate
            vcs.compDelegate = self
            vcs.addQuery = self.addIndex
        }
    }
    
    func setSpecsHidden(to val: Bool, for index: Int){
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
        setSpecsHidden(to: false, for: indexInt)
        
        self.carName[indexInt].text = self.card[indexInt]?.getCarName()
        self.price[indexInt].text = self.card[indexInt]?.getPrice()
        self.engine[indexInt].text = self.card[indexInt]?.getEngineSize()
        self.horsepower[indexInt].text = self.card[indexInt]?.getHorsePower()
        self.wheelbase[indexInt].text = self.card[indexInt]?.getWheelBase()
        self.efficiency[indexInt].text = self.card[indexInt]?.getFuelEff()
        self.capacity[indexInt].text = self.card[indexInt]?.getFuelCap()
        self.sales[indexInt].text = self.card[indexInt]?.getSales()
        
        self.carImage[indexInt].image = self.card[indexInt]?.carImg?.image
    }
    
    
    @IBAction func addCar1(_ sender: Any) {
        // Assign the add query before segue
        addIndex = 0
    }
    
    @IBAction func addCar2(_ sender: Any) {
        addIndex = 1
    }
}
