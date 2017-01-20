//
//  SettingsViewController.swift
//  Lifesaver
//
//  Created by Grant McSheffrey on 2016-11-27.
//  Copyright © 2016 Grant McSheffrey. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    
    var tapRecognizer: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.didTapAnywhere(tapRecognizer:)))
        self.view.addGestureRecognizer(self.tapRecognizer!);

        nameField.text = User.localUser.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapAnywhere(tapRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func nameChanged(sender: AnyObject) {
        User.localUser.name = nameField.text!
    }
}
