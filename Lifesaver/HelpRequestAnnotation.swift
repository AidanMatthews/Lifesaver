//
//  HelpRequestAnnotation.swift
//  Lifesaver
//
//  Created by Grant McSheffrey on 2017-01-10.
//  Copyright © 2017 Grant McSheffrey. All rights reserved.
//

import UIKit
import MapKit

class HelpRequestAnnotation: NSObject, MKAnnotation {
    var helpRequest: HelpRequest
    let coordinate: CLLocationCoordinate2D

    init(helpRequest: HelpRequest) {
        self.helpRequest = helpRequest
        self.coordinate = helpRequest.coordinate
    }

    var title: String? {
        return HelpRequest.stringForEmergencyReason(reason: self.helpRequest.emergencyReason)
    }

    var subtitle: String? {
        return self.helpRequest.additionalInfo
    }
}
