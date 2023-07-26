//
//  LocationManager.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/20.
//

import CoreLocation
import UIKit

class MyLocationManager : NSObject{
    
    static let shared = MyLocationManager()
    
    var locationManager = CLLocationManager()
    var completion : ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation)) -> Void){
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}

extension MyLocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
}


