//
//  TasksDetailTableViewController.swift
//  Shedule
//
//  Created by Denis Zayakin on 8/30/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit
import UserNotifications

class TasksDetailTableViewController: UITableViewController, UITextViewDelegate, UIGestureRecognizerDelegate, UNUserNotificationCenterDelegate {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!

    @IBOutlet weak var finishSwitch: UISwitch!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var notePlaceholderLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var condition: DetailCondition?
    var selectedTask: Task?
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        noteTextView.delegate = self
        
        switch condition {
        case .add?: do {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
            }
        case .edit?: do {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(saveButton))
            if noteTextView.text != nil  { notePlaceholderLabel.text = "" }
            taskTextField.text = selectedTask?.details
            subjectTextField.text = (selectedTask?.subject)!
            datePicker.date = (selectedTask?.finishTime)!
            finishSwitch.isOn = (selectedTask?.isDone)!
            noteTextView.text = (selectedTask?.note)!
            if notePlaceholderLabel.text!.count == 0 { notePlaceholderLabel.text = "Note" }
            }
        case .none:
            debugPrint("none")
        }

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        self.tableView.addGestureRecognizer(swipeDown)
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0  { notePlaceholderLabel.text = "" }
        if textView.text.count == 0 { notePlaceholderLabel.text = "Note" }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        switch condition {
        case .add?: do {
            let task = Task(id: UUID().uuidString, details: taskTextField.text!, subject: subjectTextField.text!, finishTime: datePicker.date, remindTime: Calendar.current.date(byAdding: .minute, value: -1, to: datePicker.date)!, isDone: finishSwitch.isOn, note: noteTextView.text!)
            DataSource.shared.appendTask(task: task) { [weak self] (error: Error?) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                self!.sendNotification(task: task)
                self?.navigationController?.popViewController(animated: true)
            }
            }
        case .edit?: do {
            let task = Task(id: (selectedTask?.id)!, details: taskTextField.text!, subject: subjectTextField.text!, finishTime: datePicker.date, remindTime: Calendar.current.date(byAdding: .minute, value: -1, to: datePicker.date)!, isDone: finishSwitch.isOn, note: noteTextView.text!)
            DataSource.shared.updateTask(task) { [weak self] (error: Error?) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                self?.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [(self!.selectedTask?.id)!])
                self!.userNotificationCenter.removeDeliveredNotifications(withIdentifiers: [(self!.selectedTask?.id)!])
                self!.sendNotification(task: task)
                self?.navigationController?.popViewController(animated: true)
            }
            }
        case .none:
            debugPrint("none")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
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
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }

}
