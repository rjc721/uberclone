//
//  ViewController.swift
//  uberclone
//
//  Created by Ryan Chingway on 5/20/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionButton: RoundedShadowButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    @IBAction func actionBtnPressed(_ sender: Any) {
        actionButton.animateButton(shouldLoad: true, withMessage: nil)
    }
    
}

