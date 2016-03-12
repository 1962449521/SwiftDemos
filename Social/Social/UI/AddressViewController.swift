//
//  AddressViewController.swift
//  Social
//
//  Created by 胡 帅 on 15/5/18.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import UIKit
import MapKit


class AddressViewController: UIViewController {
    var address:NSString?
    var mapView:MKMapView?
    @IBOutlet weak var addressTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView = MKMapView(frame: view.bounds)
        self.view.addSubview(mapView!)
        addressTextField!.text = address as! String
        self.view.bringSubviewToFront(addressTextField!)
        
        CLGeocoder().geocodeAddressString(address! as String,
            completionHandler: geocoderFunc)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    // Geo coder
    func geocoderFunc(marks:[AnyObject]!, erro:NSError!){
        if(marks == nil || marks.count == 0){
            UIAlertView(title: "Alert", message: "Not Found", delegate: nil, cancelButtonTitle: "OK")
        }
        else{
            println("The count of mark:\(marks.count)")
            let firstPlacemark = marks[0] as! CLPlacemark
            println("The name of this mark is:\(firstPlacemark.addressDictionary)")
//            let firstPlacemark2 = marks[1] as! CLPlacemark
//            println("The name of this mark is:\(firstPlacemark2.addressDictionary)")

            let coordinate     = firstPlacemark.location.coordinate
            mapView?.setRegion(MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1, 0.1)), animated: true)
        }
    }

}
