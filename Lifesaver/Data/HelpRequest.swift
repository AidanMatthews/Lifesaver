//
//  HelpRequest.swift
//  Lifesaver
//
//  Created by Grant McSheffrey on 2016-09-30.
//  Copyright © 2016 Grant McSheffrey. All rights reserved.
//

import UIKit
import MapKit

struct HelpRequest {
    var notifyRadius = 3
    var call911 = true
    var emergencyReason = 0
    var additionalInfo = ""
    var coordinate: CLLocationCoordinate2D

    static func stringForEmergencyReason(reason: Int) -> String {
        switch reason {
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
        case 5:
            return "Other"
        default:
            return "Invalid reason"
        }
    }
}

