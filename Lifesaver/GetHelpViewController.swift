//
//  GetHelpViewController.swift
//  Lifesaver
//
//  Created by Grant McSheffrey on 2016-09-30.
//  Copyright © 2016 Grant McSheffrey. All rights reserved.
//

import UIKit

class GetHelpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var notifyRadiusText: UITextField!
    @IBOutlet weak var call911Switch: UISwitch!
    @IBOutlet weak var emergencyPicker: UIPickerView!
    @IBOutlet weak var additionalInfoText: UITextField!
    @IBOutlet weak var getHelpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedGetHelpButton(sender: UIButton) {
        var request = HelpRequest()
        request.userId = 1
        
        request.notifyRadius = notifyRadiusText.text!.characters.count > 0 ? Int(notifyRadiusText.text!)! : 3
        request.call911 = call911Switch.isOn
        request.emergencyDesc = emergencyPicker.selectedRow(inComponent: 0)
        request.additionalInfo = additionalInfoText.text!
    }
    
    // UIPickerViewDataSource methods
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    // UIPickerViewDelegate methods
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
            case 0:
                return "Urgent help needed"
            case 1:
                return "Out of gas"
            case 2:
                return "Injured"
            case 3:
                return "Medical emergency"
            case 4:
                return "Weather emergency"
            default:
                return "Other"
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

