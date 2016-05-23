//
//  Dude,Here'sYourCar.swift
//  Dude,WheresMyCar?
//
//  Created by Jorge Catalan on 5/23/16.
//  Copyright © 2016 Jorge Catalan. All rights reserved.
//

import Foundation

class Car: NSObject,NSCoding{
    internal var title: String?
    internal var lat: Double?
    internal var long: Double?
    
    //Archive
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("car")
    //init
    init?(title: String,
          lat: Double, long: Double) {
        
        self.title = title
        self.lat = lat
        self.long = long
        
        super.init()
        
        if title.isEmpty {
            return nil
        }
    }
    
    //Coder
    required convenience init?(coder aDecoder:NSCoder) {  guard let title = aDecoder.decodeObjectForKey("title") as? String,
            lat = aDecoder.decodeObjectForKey("lat") as? Double,
            long = aDecoder.decodeObjectForKey("long") as? Double
            else {
                return nil
        }
        
        self.init(title:title, lat:lat, long:long)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(lat!, forKey: "lat")
        aCoder.encodeDouble(long!, forKey: "long")
        aCoder.encodeObject(title, forKey: "title")
        // aCoder.encodeObject(subtitle, forKey: "subtitle")
        
    }
    
}

