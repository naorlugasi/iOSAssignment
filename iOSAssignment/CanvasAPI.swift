//
//  CanvasAPI.swift
//  iOSAssignment
//
//  Created by Naor Lugassi on 12/12/17.
//  Copyright © 2017 Naor Lugassi. All rights reserved.
//

import UIKit
import CoreData

class CanvasAPI: NSObject {

    static let sharedInstance = CanvasAPI()

    
    func save(image: UIImage , startDate: Date, endDate: Date, totalTime: Double) {
        
        let canvas = Canvas(context: CoreDataStack.managedObjectContext)
        canvas.imageData = UIImageJPEGRepresentation(image, 1) as NSData?
        canvas.startDate = startDate as NSDate
        canvas.endDate = endDate as NSDate
        canvas.totalTime = totalTime
        CoreDataStack.saveContext()
    }
    
    func getCanvasList() ->[Canvas] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Canvas")
        do {
            let result = try CoreDataStack.managedObjectContext.fetch(request)
            if let list = result as? [Canvas] {
                return list
            }
        } catch {
            
            print("Failed")
        }
        
        return []
    }
    
    func deleteCanvas(startDate: Date) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Canvas")
        request.predicate = NSPredicate(format: "startDate = %@", startDate as CVarArg)
        request.returnsObjectsAsFaults = false
        do {
            let result = try CoreDataStack.managedObjectContext.fetch(request)
            if let list = result as? [Canvas] {
                if list.count == 1{
                    CoreDataStack.managedObjectContext.delete(list.first!)
                }
            }
        } catch {
            
            print("Failed")
        }
    }

}
