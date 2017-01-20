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
}
