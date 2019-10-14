//
//  NotificationManagement.swift
//  Shedule
//
//  Created by Denis Zayakin on 10/14/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func sendNotification(task: Task) {
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,], from: task.remindTime)
        let content = UNMutableNotificationContent()
        let podcastName = "tasks"
        content.title = task.subject
        content.body = "1 hour left for \(task.details)"
        content.threadIdentifier = podcastName.lowercased()
        content.summaryArgument = podcastName
        content.sound = UNNotificationSound.default
        //TODO: badge count
        //content.badge = NSNumber(value: ViewController.notificationCount + 1 )
        //ViewController.notificationCount += 1
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: task.id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func deleteNotification(task: Task) {
        self.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [(task.id)])
        self.userNotificationCenter.removeDeliveredNotifications(withIdentifiers: [(task.id)])
    }
    
    func editNotification(task: Task) {
        deleteNotification(task: task)
        sendNotification(task: task)
    }
    
}
