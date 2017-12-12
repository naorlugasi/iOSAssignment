//
//  DrawingListVC.swift
//  iOSAssignment
//
//  Created by Naor Lugassi on 12/12/17.
//  Copyright © 2017 Naor Lugassi. All rights reserved.
//

import UIKit

class DrawingListVC: UITableViewController, RefreshDelegate {

    var canvasList = [Canvas]()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshListDate()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshListDate(){
        canvasList = CanvasAPI.sharedInstance.getCanvasList()
         self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canvasList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        let canvas = self.canvasList[indexPath.row]
        cell.textLabel?.text = dateFormatter.string(from: canvas.startDate! as Date)
        cell.detailTextLabel?.text = String(format:"%.02f", canvas.totalTime) + " Mintue work time"
        cell.imageView?.image = UIImage(data: canvas.imageData! as Data)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "canvas", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            CanvasAPI.sharedInstance.deleteCanvas(startDate: self.canvasList[indexPath.row].startDate! as Date)
            self.canvasList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "canvas" {
            if let vc = segue.destination as? CanvasVC {
                vc.delegate = self
                if let indexPath = tableView.indexPathForSelectedRow{
                    let selectedRow = indexPath.row
                    if let img = self.canvasList[selectedRow].imageData as Data?{
                        vc.selectedCanvas = UIImage(data: img)
                        vc.startDate = self.canvasList[selectedRow].startDate! as Date
                        vc.workTime = self.canvasList[selectedRow].totalTime
                    }
                }
            }
        }
    }
}



extension Date {
    
    func offsetFrom(date: Date) -> Double {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let seconds = (difference.second ?? 0)
        let minutes = (difference.minute ?? 0) + seconds
        let hours = (difference.hour ?? 0) + minutes
        let days = (difference.day ?? 0) + hours
        
        if let day = difference.day, day          > 0 { return Double(days) * 24 * 60 }
        if let hour = difference.hour, hour       > 0 { return Double(hours) * 60 }
        if let minute = difference.minute, minute > 0 { return Double(minutes) }
        if let second = difference.second, second > 0 { return Double(seconds) / 60 }
        return 0
    }
    
}
