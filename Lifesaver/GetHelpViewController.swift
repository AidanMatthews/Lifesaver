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

    var tapRecognizer: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.didTapAnywhere(tapRecognizer:)))
        self.view.addGestureRecognizer(self.tapRecognizer!);
    }

    func didTapAnywhere(tapRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func tappedGetHelpButton(sender: UIButton) {
        let notifyRadius = notifyRadiusText.text!.characters.count > 0 ? Int(notifyRadiusText.text!)! : 3
        
        let request = HelpRequest(notifyRadius: notifyRadius,
                                  call911: call911Switch.isOn,
                                  emergencyReason: emergencyPicker.selectedRow(inComponent: 0),
                                  additionalInfo: additionalInfoText.text!,
                                  coordinate: CurrentLocation.sharedInstance.currentCoordinate)

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

