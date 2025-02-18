//
//  SettingsViewController.swift
//  cis357_hw2
//
//  Created by Bryan Soriano and Autumn Bertram on 9/24/23.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsChanged(distanceUnits: String, bearingUnits: String)
}

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var distanceText: UILabel!
    @IBOutlet weak var bearingText: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    
    
    var pickerData: [String] = [String]()
    var distanceUnits: String = ""
    var bearingUnits: String = ""
    var delegate : SettingsViewControllerDelegate?
    
    var originalDistanceText:String = ""
    var originalBearingText:String = ""
    
    var saveDistanceText: String = ""
    var saveBearingText: String = ""
    
    var selectedDistanceRow = 0
    var selectedBearingRow = 0
    
    var selectedDistanceUnits: String = ""
    var selectedBearingUnits: String = ""
    var initialDistanceText: String = ""
    var initialBearingText: String = ""


    override func viewDidLoad() {
        super.viewDidLoad()

        picker.dataSource = self
        picker.delegate = self
        
        selectedDistanceUnits = distanceText.text ?? ""
        selectedBearingUnits = bearingText.text ?? ""
        initialDistanceText = selectedDistanceUnits
        initialBearingText = selectedBearingUnits

        /*
        // Do any additional setup after loading the view.
        if picker.tag == 0 {
            self.pickerData = ["Kilometers", "Miles"]
        }
        else if picker.tag == 1 {
            self.pickerData = ["Degrees", "Mils"]
        }
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        selectedDistanceRow = picker.selectedRow(inComponent: 0)
        selectedBearingRow = picker.selectedRow(inComponent: 0)
        
        if self.picker.tag == 1 {
            if let index = pickerData.firstIndex(of: self.bearingUnits){
                self.picker.selectRow(index, inComponent: 0, animated: true)
            }
        }
        else if self.picker.tag == 0 {
            if let index = pickerData.firstIndex(of: self.distanceUnits) {
                self.picker.selectRow(index, inComponent: 0, animated: true)
            }
        }
        else {
            self.picker.selectRow(0, inComponent: 0, animated: true)
        }
        */

        let distanceTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        distanceText.isUserInteractionEnabled = true
        distanceText.addGestureRecognizer(distanceTapGesture)
        let bearingTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        bearingText.isUserInteractionEnabled = true
        bearingText.addGestureRecognizer(bearingTapGesture)
        
        originalDistanceText = distanceText.text!
        originalBearingText = bearingText.text!
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOutside(_:)))
            view.addGestureRecognizer(tapGestureRecognizer)
    
            
        }
    
    @IBAction func cancelButton(_ sender: Any) {
        distanceText.text = originalDistanceText
        bearingText.text = originalBearingText

        self.navigationController?.dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)

           if let d = self.delegate {
               d.settingsChanged(distanceUnits: distanceUnits, bearingUnits: bearingUnits)
           }
       }
    
    
    
    @objc func tapOutside(_ sender: UITapGestureRecognizer) {
        let tap = sender.location(in: view)
        
        if !picker.frame.contains(tap) && !distanceText.frame.contains(tap) && !bearingText.frame.contains(tap) {
            picker.isHidden = true
        }
    }

    
    
    //There is an issue where if you change the distanceText to miles(2nd field in picker), and then click on the bearingText, it auto updates it to the 2nd field in picker.
    @objc func tap(_ text: UITapGestureRecognizer) {

            if text.view == distanceText {
                self.pickerData = ["Kilometers", "Miles"]
                let selected = picker.selectedRow(inComponent: 0)
                distanceText.text = pickerData[selected]
                distanceUnits = pickerData[selected]
                picker.selectRow(selectedDistanceRow, inComponent: 0, animated: true)
                saveDistanceText = pickerData[selected]
            }
            else if text.view == bearingText {
                self.pickerData = ["Degrees", "Mils"]
                let selected = picker.selectedRow(inComponent: 0)
                bearingText.text = pickerData[selected]
                bearingUnits = pickerData[selected]
                picker.selectRow(selectedBearingRow, inComponent: 0, animated: true)
                saveBearingText = pickerData[selected]
            }
        
        
            picker.reloadAllComponents()
            
            if picker.isHidden {
                picker.isHidden = false
            }
            else {
                picker.isHidden = true
            }

        }
    
    
    //SAVE DOES NOT WORK, WHEN YOU OPEN IT AFTER SAVING, PREVIOUS VALUE NOT STORED
    @IBAction func saveButton(_ sender: Any) {
        
            self.dismiss(animated: true, completion: nil)
    }
  
    }


    

    
    
    
    
    
    






extension SettingsViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.distanceUnits = self.pickerData[row]
            self.bearingUnits = self.pickerData[row]
    }
    
}


