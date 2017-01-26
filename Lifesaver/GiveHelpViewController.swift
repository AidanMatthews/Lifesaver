//
//  GiveHelpViewController.swift
//  Lifesaver
//
//  Created by Grant McSheffrey on 2016-09-30.
//  Copyright © 2016 Grant McSheffrey. All rights reserved.
//

import UIKit
import MapKit

class GiveHelpViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var button: UIButton!

    let regionRadius: CLLocationDistance = 1000
    var localHelpRequests: Array<HelpRequest> = Array()
    var updateTimer: Timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // set initial location in Honolulu
        let currentCoordinate = CurrentLocation.sharedInstance.currentCoordinate
        centerMapOnLocation(location: currentCoordinate)
        print("Initializing to latitude: \(currentCoordinate.latitude), longitude: \(currentCoordinate.longitude)")

        self.updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: {[unowned self] (Timer) in
            self.localHelpRequests = DataHelper.sharedInstance.getLocalHelpRequests(currentLocation: currentCoordinate)
            self.updateAnnotations()
        })
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = self.map.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
        }
        return view
    }

    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(
            location, regionRadius * 2.0, regionRadius * 2.0)
        self.map.setRegion(coordinateRegion, animated: true)
    }
    
    func updateAnnotations() {
        for request: HelpRequest in self.localHelpRequests {
            let annotation = HelpRequestAnnotation(helpRequest: request)
            self.map.addAnnotation(annotation)
            print("Adding annotation at latitude: \(request.coordinate.latitude), longitude: \(request.coordinate.longitude)")
        }
    }
}

