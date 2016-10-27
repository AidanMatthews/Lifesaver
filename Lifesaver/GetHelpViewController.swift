//
//  GetHelpViewController.swift
//  Lifesaver
//
//  Created by Grant McSheffrey on 2016-09-30.
//  Copyright © 2016 Grant McSheffrey. All rights reserved.
//

import UIKit

class GetHelpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let _emergencies: [Int: String] = [0: "Urgent help needed",
                                             1: "Out of gas",
                                             2: "Injured",
                                             3: "Medical emergency",
                                             4: "Weather emergency",
                                             5: "Other"]

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
        
        request.notifyRadius = notifyRadiusText.text!.characters.count > 0 ? Int(notifyRadiusText.text!)! : 3
        request.call911 = call911Switch.isOn
        request.emergencyReason = emergencyPicker.selectedRow(inComponent: 0)
        request.additionalInfo = additionalInfoText.text!
        
        Server.sharedInstance.sendRequest(request: request)
    }
    
    // UIPickerViewDataSource methods
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _emergencies.count
    }
    
    // UIPickerViewDelegate methods
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _emergencies[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

