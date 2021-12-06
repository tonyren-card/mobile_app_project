//
//  ViewCompare.swift
//  iosCard
//
//  Created by Tony Ren on 2021-12-06.
//  Copyright © 2021 TonyRen. All rights reserved.
//

import UIKit

class ViewCompare: UIViewController {
    @IBOutlet var price: [UILabel]!
    @IBOutlet var engine: [UILabel]!
    @IBOutlet var horsepower: [UILabel]!
    @IBOutlet var wheelbase: [UILabel]!
    @IBOutlet var efficiency: [UILabel]!
    @IBOutlet var capacity: [UILabel]!
    @IBOutlet var sales: [UILabel]!
    @IBOutlet var addBtn: [UIButton]!
    @IBOutlet var removeBtn: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSpecsHidden(to: true, for: 0)
        setSpecsHidden(to: true, for: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vcs = segue.destination as? ViewCompareSearch{
            vcs.vcDelegate = tabBarController?.viewControllers?[0] as? CompareDelegate
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
}
