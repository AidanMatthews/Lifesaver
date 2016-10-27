//
//  Server.swift
//  Lifesaver
//
//  Created by Grant McSheffrey on 2016-10-26.
//  Copyright © 2016 Grant McSheffrey. All rights reserved.
//

import UIKit

class Server: NSObject {
    static let sharedInstance = Server()

    func sendRequest(request: HelpRequest) {
        let dataHelper = DataHelper.sharedInstance
        
        dataHelper.addRequest(userId: Int32(User.localUser.id), notifyRadius: Int32(request.notifyRadius), call911: request.call911, emergencyReason: Int32(request.emergencyReason), otherInfo: request.additionalInfo)
    }
}
