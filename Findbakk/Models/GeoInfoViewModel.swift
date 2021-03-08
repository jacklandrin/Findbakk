//
//  GeoInfoViewModel.swift
//  Findbakk
//
//  Created by jack on 2021/3/4.
//

import Foundation
import Combine
import MapKit
import SwiftUI

let defaultDelta:Double = 0.2
let lostPlaces = [
    LostInfoViewModel(imageTitle:"Cat", latitude: 52.318580, longitude: 4.974558),
    LostInfoViewModel(imageTitle:"Cat", latitude: 52.386636, longitude: 4.908924),
    LostInfoViewModel(imageTitle:"Cat", latitude: 52.348687, longitude: 4.895693),
]

class GeoInfoViewModel: NSObject, ObservableObject {
    var hasLocated: Bool = false
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var latitudeDelta: Double = defaultDelta
    var longitudeDelta: Double = defaultDelta
    var places = lostPlaces
    var trackingMode:MapUserTrackingMode = MapUserTrackingMode.follow
    
    var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 52.3284912109375, longitude: 4.957738816192544), span: MKCoordinateSpan(latitudeDelta: defaultDelta, longitudeDelta: defaultDelta))
    {
        willSet {
            latitudeDelta = region.span.latitudeDelta
            longitudeDelta = region.span.longitudeDelta
//            print("\(latitudeDelta) , \(longitudeDelta)")
            print("current center \(String(describing: region.center.latitude)),\(String(describing: region.center.longitude))")
        }
    }
    private let locationManager: LocationManager = LocationManager()
    private var repoSubscriptions = Set<AnyCancellable>()
    override init() {
        super.init()
        
        let subscribe = locationManager.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] _ in
                guard let strongSelf = self else {return}
                print("received \(String(describing: strongSelf.locationManager.location?.latitude)),\(String(describing: strongSelf.locationManager.location?.longitude))")
                guard strongSelf.hasLocated == false else { return }
                strongSelf.latitude = strongSelf.locationManager.location?.latitude ?? 0.0
                strongSelf.longitude = strongSelf.locationManager.location?.longitude ?? 0.0
                strongSelf.objectWillChange.send()
                strongSelf.hasLocated = true
            })
        subscribe.store(in: &repoSubscriptions)
    }
    
    func backMyLocation() {
        guard self.hasLocated == true else {
            return
        }
        self.latitude = self.locationManager.location?.latitude ?? 0.0
        self.longitude = self.locationManager.location?.longitude ?? 0.0
        self.latitudeDelta = defaultDelta
        self.longitudeDelta = defaultDelta
        self.objectWillChange.send()
    }
    
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManger = CLLocationManager()
    
    @Published var location: CLLocation? {
        willSet { objectWillChange.send() }
    }
    
    override init() {
        super.init()
        self.locationManger.delegate = self
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManger.requestAlwaysAuthorization()
        self.locationManger.requestLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let location =  manager.location else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}
