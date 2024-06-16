//
//  LocationManager.swift
//  WeatherPlan
//
//  Created by Yunki on 6/14/24.
//

import CoreLocation

class LocationManager: NSObject {
    private var locationManager: CLLocationManager?
    
    private var locationUpdateHandler: ((CLLocation) -> ())?
    
    private var updateState = false
    
    var locationAvalible: Bool {
        return locationManager?.authorizationStatus == .authorizedWhenInUse
    }
    
    func triggerHandler() {
        updateState.toggle()
    }
    
    /// LocationManager Initializer
    /// - Parameters:
    ///   - locationManager: CLLocationManager 객체
    ///   - locationUpdateHandler: Location이 Update될 때 실행될 클로저
    init(locationManager: CLLocationManager, locationUpdateHandler: @escaping (CLLocation) -> ()) {
        super.init()
        
        self.locationManager = locationManager
        locationManager.delegate = self
        
        self.locationUpdateHandler = locationUpdateHandler
        
        locationManager.startUpdatingLocation()
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
