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
    @IBOutlet weak var leaveTimeTextField: UITextField!
    
  
    
    var pickerView = UIPickerView()
    var datePicker = UIDatePicker()
    var stationManager = StationManager()
    let citys = ["基隆市","新北市","臺北市","桃園市","新竹縣","新竹市","苗栗縣","臺中市","彰化縣","南投縣","雲林縣","嘉義縣","嘉義市","臺南市","高雄市","屏東縣","臺東縣","花蓮縣","宜蘭縣"]
    
    var stationDict: Dictionary<String,StationModel> = [:]
    var cityDict: Dictionary<String,[String]> = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        stationManager.delegate = self
        stationManager.getAllStationInfo()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        datePickerSetting()
        
        
        leaveTimeTextField.backgroundColor = .secondarySystemBackground
        leaveTimeTextField.inputView = datePicker
        leaveTimeTextField.inputAccessoryView = createToolBar()
        leaveTimeTextField.borderStyle = .roundedRect
        
        
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
    
    @IBAction func searchTrainPressed(_ sender: UIButton) {
                print("button")
        
            performSegue(withIdentifier: "goToTrainTime", sender: self)
        
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TrainTimeTableViewController {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let leaveTimeStr = formatter.string(from: datePicker.date)
            
            if let startStation = startTextField.text, let endStation = endTextField.text {
                TrainManager.shared.startStation = stationDict[startStation]!.ID
                TrainManager.shared.endStation = stationDict[endStation]!.ID
                TrainManager.shared.leaveTime = leaveTimeStr
                
//                print(TrainManager.shared)
                
            }
        }
    }
    
    func datePickerSetting() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = .now
        datePicker.date = .now
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "zh_GB")
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        let calender = Calendar.current
        let components = calender.dateComponents([.day,.month,.year,.hour,.minute],from: self.datePicker.date)
        guard let year = components.year, let month = components.month, let day = components.day, let hour = components.hour, let minutes = components.minute else {
            fatalError("時間有誤")
        }
        leaveTimeTextField.text = "\(year)年\(month)月\(day)日 \(hour)點\(minutes)分 出發"
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return citys.count
        } else {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            
            return cityDict[citys[selectedRow]]?.count ?? 0
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return citys[row]
        } else {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            return cityDict[citys[selectedRow]]?[row]
            
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
            startTextField.text = cityDict[citys[cityRow]]?[stationRow]
        } else if endTextField.isEditing {
            
            endTextField.text = cityDict[citys[cityRow]]?[stationRow]
        }
        
    }
      
    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 130/255, green: 150/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func donePicker() {
        view.endEditing(true)
    }
    
    @objc func datePickerChanged() {
        let calender = Calendar.current
        let components = calender.dateComponents([.day,.month,.year,.hour,.minute],from: self.datePicker.date)
        guard let year = components.year, let month = components.month, let day = components.day, let hour = components.hour, let minutes = components.minute else {
            fatalError("時間有誤")
        }
        leaveTimeTextField.text = "\(year)年\(month)月\(day)日 \(hour)點\(minutes)分 出發"
        
    }
}

extension HomeViewController: Station {
    func updateAllStationToArray(_ stationData: StationData) {
        for station in stationData.Stations {
            stationDict[station.StationName.Zh_tw] = StationModel(name: station.StationName.Zh_tw, ID: station.StationID, address: station.StationAddress)
            
            for city in citys {
                if station.StationAddress.contains(city) {
                    cityDict[city, default: []].append(station.StationName.Zh_tw)
                }
            }
        }
//        print(stationDict)
//        print(cityDict)
    }
}

