//
//  ViewController.swift
//  WeatherTrain
//
//  Created by 林育生 on 2023/9/9.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
  
    
    var pickerView = UIPickerView()
    
    
    let city = ["台北","新北","桃園"]
    let station = [["台北","萬華"],["板橋","樹林","鶯歌"],["桃園","中壢","楊梅","富岡"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
          
        pickerView.delegate = self
        pickerView.dataSource = self
        
        startTextField.inputView = pickerView
        endTextField.inputView = pickerView
        startTextField.inputAccessoryView = createToolBar()
        endTextField.inputAccessoryView = createToolBar()
        
        startTextField.borderStyle = .roundedRect
        startTextField.backgroundColor = .secondarySystemBackground
        endTextField.borderStyle = .roundedRect
        endTextField.backgroundColor = .secondarySystemBackground
       
    }

    @IBAction func switchStationPressed(_ sender: UIButton) {
        guard let startStation = startTextField.text, let endStation = endTextField.text else {
            print("切換失敗")
            return
        }
        startTextField.text = endStation
        endTextField.text = startStation
    }
    
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return city.count
        } else {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            
            return station[selectedRow].count
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return city[row]
        } else {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            return station[selectedRow][row]
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        pickerView.reloadComponent(1)
        
        let cityRow = pickerView.selectedRow(inComponent: 0)
        let stationRow = pickerView.selectedRow(inComponent: 1)
        if startTextField.isEditing {
            startTextField.text = station[cityRow][stationRow]
        } else if endTextField.isEditing {
            
            endTextField.text = station[cityRow][stationRow]
        }
        
    }
    @objc func donePicker() {
        
        startTextField.resignFirstResponder()
        endTextField.resignFirstResponder()
        
    }
    
    
    
    func createToolBar() -> UIToolbar {
        var toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 142/255, green: 205/255, blue: 221/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
