//
//  ChecklistItem.swift
//  CheckLists
//
//  Created by Panagiotis Siapkaras on 5/25/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem : NSObject , NSCoding{
    var text = ""
    var checked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        
        aCoder.encode(itemID, forKey: "ItemID")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(dueDate, forKey: "DueDate")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = (aDecoder.decodeObject(forKey: "Checked") != nil)
        
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        
        super.init()
    }
    
    override init(){
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    func toggleChecked(){
        checked = !checked
    }
    
    //MARK: - Local Notifications
    
    func scheduleNotification(){
        removeNotification()
        if shouldRemind && dueDate > Date(){
            
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month , .day , .hour , .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
            
            print("Scheduled notification \(request) for itemID \(itemID)")
            
        }
    }
    
    
    func removeNotification(){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    deinit{
        removeNotification()
    }
}
