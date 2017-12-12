//
//  Canvas+CoreDataProperties.swift
//  iOSAssignment
//
//  Created by Naor Lugassi on 12/12/17.
//  Copyright © 2017 Naor Lugassi. All rights reserved.
//
//

import Foundation
import CoreData


extension Canvas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Canvas> {
        return NSFetchRequest<Canvas>(entityName: "Canvas")
    }

    @NSManaged public var startDate: NSDate?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var imageData: NSData?
    @NSManaged public var totalTime: Double

}
