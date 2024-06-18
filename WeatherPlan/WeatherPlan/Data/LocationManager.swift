//
//  LocationManager.swift
//  WeatherPlan
//
//  Created by Yunki on 6/14/24.
//

import CoreLocation

class LocationManager: NSObject, LocationInterface {
    private var locationManager: CLLocationManager?
    
    private var updateState = false
    
    /// Location이 Update될 때 실행되는 클로저
    var locationUpdateHandler: ((CLLocation) -> ())?
    
    var locationAvalible: Bool {
        return locationManager?.authorizationStatus == .authorizedWhenInUse
    }
    
    func triggerHandler() {
        updateState = true
    }
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        
        self.locationManager?.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // 위치 권한 변경되면 호출되는 메서드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .denied:
            break
        case .restricted:
            break
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
        @unknown default:
            fatalError()
        }
    }
    
    // 위치정보 갱신되면 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if updateState {
            locationUpdateHandler?(location)
        }
        updateState = false
    }
}
