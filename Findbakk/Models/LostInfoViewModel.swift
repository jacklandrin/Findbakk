//
//  LostInfoViewModel.swift
//  Findbakk
//
//  Created by jack on 2021/3/5.
//

import Foundation
import MapKit

enum LostType {
    case Things, Person, Pet
}

class Place:Identifiable {
    var imageTitle:String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    let id = UUID()
}

extension Place {
    var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
}

class LostInfoViewModel: Place {
    var title:String = ""
    var description: String = ""
    var lostType: LostType = .Things
    var lostOrFind : Bool = true
    init(imageTitle: String, latitude: Double, longitude: Double) {
        super.init()
        self.imageTitle = imageTitle
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(imageTitle: String, latitude: Double, longitude: Double, title: String, description: String, lostType: LostType, lostOrFind: Bool) {
        self.init(imageTitle:imageTitle, latitude: latitude, longitude: longitude)
        self.description = description
        self.lostType = lostType
        self.lostOrFind = lostOrFind
    }
}

class MyLocationViewModel: Place {
    init(imageTitle: String, latitude: Double, longitude: Double) {
        super.init()
        self.imageTitle = imageTitle
        self.latitude = latitude
        self.longitude = longitude
    }
}

