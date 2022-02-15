//
//  AdvancedSearch.swift
//  iosCard
//
//  Created by Tony Ren on 2022-02-02.
//  Copyright © 2022 TonyRen. All rights reserved.
//

import UIKit

class AdvancedSearch: UIViewController {

    @IBOutlet weak var makeField: UITextField!
    @IBOutlet var priceRange: [UITextField]!
    @IBOutlet var engineRange: [UITextField]!
    @IBOutlet var hpRange: [UITextField]!
    @IBOutlet var wbRange: [UITextField]!
    @IBOutlet var feRange: [UITextField]!
    @IBOutlet var fcRange: [UITextField]!
    @IBOutlet var salesRange: [UITextField]!
    @IBOutlet var launchRange: [UITextField]!
    
    var rangeField: [[UITextField]?]!
    
//     var invalidLabel
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    let datePickerLaunch = UIDatePicker()
//    var datePickerLaunch = [UIDatePicker](repeating: UIDatePicker(), count: 2)
    
    //more like init
    override func loadView() {
        super.loadView()
        
        rangeField = [priceRange,
                                        engineRange,
                                        hpRange,
                                        wbRange,
                                        feRange,
                                        fcRange,
                                        salesRange,
                                        launchRange]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchRange[0].isHidden = true
        launchRange[1].isHidden = true
        addDoneExtensions()
//        createDatePicker()
    }
    
    func addDoneExtensions(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnHandler))
        toolbar.setItems([doneBtn], animated: true)
        
        self.makeField.inputAccessoryView = toolbar
        
        for i in 0...1 {
            self.priceRange[i].inputAccessoryView = toolbar
            self.engineRange[i].inputAccessoryView = toolbar
            self.hpRange[i].inputAccessoryView = toolbar
            self.wbRange[i].inputAccessoryView = toolbar
            self.feRange[i].inputAccessoryView = toolbar
            self.fcRange[i].inputAccessoryView = toolbar
            self.salesRange[i].inputAccessoryView = toolbar
//            self.launchRange[i].inputAccessoryView = toolbar
        }
    }
    
//    func createDatePicker(){
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnHandler))
//        toolbar.setItems([doneBtn], animated: true)
//
//        launchRange[0].inputAccessoryView = toolbar
//        launchRange[1].inputAccessoryView = toolbar
//
//        launchRange[0].inputView = datePickerLaunch
//        launchRange[1].inputView = datePickerLaunch
//
//        datePickerLaunch.datePickerMode = .date
//    }
    
    @IBAction func searchPressedAction(_ sender: Any) {
        print("Search pressed")
        checkValid()
    }
    
    func checkValid(){
        //Pause
        for field in rangeField {
            if (field![0].text! > field![1].text!){
                print("min is greater than max")
                field![0].backgroundColor = .systemRed
                field![1].backgroundColor = .systemRed
            }
        }
    }
    
    @objc func doneBtnHandler(){
        print("Done pressed")
        self.view.endEditing(true)
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
