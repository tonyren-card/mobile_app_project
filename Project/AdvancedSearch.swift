//
//  AdvancedSearch.swift
//  iosCard
//
//  Created by Tony Ren on 2022-02-02.
//  Copyright © 2022 TonyRen. All rights reserved.
//

import UIKit

struct AdvancedSearchCriteria {
    var make: String = " "
    var priceRange: [Float] = Array(repeating: 0, count: 2)
    var engineRange: [Float] = Array(repeating: 0, count: 2)
    var hpRange: [Float] = Array(repeating: 0, count: 2)
    var wbRange: [Float] = Array(repeating: 0, count: 2)
    var feRange: [Float] = Array(repeating: 0, count: 2)
    var fcRange: [Float] = Array(repeating: 0, count: 2)
    var salesRange: [Float] = Array(repeating: 0, count: 2)
//    var launchRange: [Float] = Array(repeating: 0, count: 2)
}

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
    
    @IBOutlet var invalidLabel: UILabel!
    
    var searchDelegate: ViewSearchDelegate?
    var searchElements: SearchElements?
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    let makePicker = UIPickerView()
    
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
        
        makePicker.dataSource = self
        makePicker.delegate = self
        
        launchRange[0].isHidden = true
        launchRange[1].isHidden = true
        
        invalidLabel.isHidden = true
        addDoneExtensions()
//        createDatePicker()
        print(searchElements?.brands as Any)
    }
    
    //Generate the struct
    private func createStruct() -> AdvancedSearchCriteria{
        var criteria = AdvancedSearchCriteria()
        
        criteria.make = self.makeField.text!
        
        var limit: Float
        
        for i in 0...1{
            if (i==0) { limit = 0 }
            else      { limit = Float(NSIntegerMax) }
            
            criteria.priceRange[i] = Float(self.priceRange[i].text!) ?? limit
            criteria.engineRange[i] = Float(self.engineRange[i].text!) ?? limit
            criteria.hpRange[i] = Float(self.hpRange[i].text!) ?? limit
            criteria.wbRange[i] = Float(self.wbRange[i].text!) ?? limit
            criteria.feRange[i] = Float(self.feRange[i].text!) ?? limit
            criteria.fcRange[i] = Float(self.fcRange[i].text!) ?? limit
            criteria.salesRange[i] = Float(self.salesRange[i].text!) ?? limit
//            criteria.launchRange[i] = Float(self.launchRange[i].text!) ?? limit
        }
        
        return criteria
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag+1 //get tag of next field
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if (nextResponder != nil){
            nextResponder?.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
        }
        return true
    }
    
    
    func addDoneExtensions(){
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnHandler))
//        let nextBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextBtnHandler))
//        toolbar.setItems([doneBtn, nextBtn], animated: true)
//
        self.makeField.addDoneNextToolbar()
        self.makeField.inputView = makePicker

        for i in 0...1 {
            self.priceRange[i].addDoneNextToolbar()
            self.engineRange[i].addDoneNextToolbar()
            self.hpRange[i].addDoneNextToolbar()
            self.wbRange[i].addDoneNextToolbar()
            self.feRange[i].addDoneNextToolbar()
            self.fcRange[i].addDoneNextToolbar()
            self.salesRange[i].addDoneNextToolbar()
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
        print("Make: \(makeField.text!)")
        if (checkValid()){
            invalidLabel.isHidden = true
            self.dismiss(animated: true, completion: {self.sendData()})
        }else{
            invalidLabel.isHidden = false
        }
    }
    
    func checkValid() -> Bool{
        var valid = true
        for field in rangeField {
            if (Float(field![0].text!) ?? 0 > Float(field![1].text!) ?? Float(NSIntegerMax)){
                print("\(field![0].text!) is not less than \(field![1].text!)")
                field![0].backgroundColor = .systemRed
                field![1].backgroundColor = .systemRed
                valid = false
            }else{
                print("\(field![0].text!) is less than \(field![1].text!)")
                field![0].backgroundColor = .systemBackground
                field![1].backgroundColor = .systemBackground
            }
        }
        return valid
    }
    
    func sendData() {
        let structData = self.createStruct()
        
        print("Struct = \(structData)")
        
        searchDelegate?.advancedFilterData(struct: structData)
    }
    
//    @objc func doneBtnHandler(){
//        print("Done pressed")
//        self.view.endEditing(true)
//    }
//
//    @objc func nextBtnHandler(){
//        self.resignFirstResponder()
//
//        let nextTag = self.tag+1 //get tag of next field
//        let nextResponder = self.superview?.viewWithTag(nextTag)
//
//        if (nextResponder != nil){
//            nextResponder?.becomeFirstResponder()
//        }else{
//            self.endEditing(true)
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AdvancedSearch: UIPickerViewDataSource {
    // Number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchElements!.brands.count + 1
    }
}

extension AdvancedSearch: UIPickerViewDelegate{
    // Map array to picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (row == 0){
            return ""
        }
        return searchElements!.brands[row-1]
    }
    
    // Set make field to value of picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selector: String
        if (row == 0){
            selector = ""
        }else{
            selector = searchElements!.brands[row-1]
        }
        self.makeField.text = selector
    }
}

extension UITextField {
    func addDoneNextToolbar(onDone: (target: Any, action: Selector)? = nil, onNext: (target: Any, action: Selector)? = nil) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnHandler))
        let nextBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextBtnHandler))
        toolbar.setItems([doneBtn, nextBtn], animated: true)
        
        self.inputAccessoryView = toolbar
    }
    
    
    @objc func doneBtnHandler(){
        self.resignFirstResponder()
    }
    
    @objc func nextBtnHandler(){
        self.resignFirstResponder()
        
        let nextTag = self.tag+1 //get tag of next field
        let nextResponder = self.superview?.viewWithTag(nextTag)
        
        if (nextResponder != nil){
            nextResponder?.becomeFirstResponder()
        }else{
            self.endEditing(true)
        }
    }
}
