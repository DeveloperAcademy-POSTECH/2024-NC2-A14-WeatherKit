//
//  LocationInterface.swift
//  WeatherPlan
//
//  Created by Yunki on 6/16/24.
//

import CoreLocation.CLLocation

protocol LocationInterface {
    var locationUpdateHandler:  ((CLLocation) -> ())? { get set }
    var locationAvalible: Bool { get }
    func triggerHandler()
}
