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
    let notificationManager = NotificationManager()
    
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
            if noteTextView.text!.count == 0 { notePlaceholderLabel.text = "Note" }
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
        let alertController = UIAlertController(title: "Error", message:
            "Enter task", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        switch condition {
        case .add?: do {
            let newTask = Task(id: UUID().uuidString, details: taskTextField.text!, subject: subjectTextField.text!, finishTime: datePicker.date, remindTime: Calendar.current.date(byAdding: .minute, value: 0, to: datePicker.date)!, isDone: finishSwitch.isOn, note: noteTextView.text!, photo: UIImage(named: "") ?? nil)
            if newTask.details == "" {
                self.present(alertController, animated: true, completion: nil)
            } else {
                DataSource.shared.appendTask(task: newTask) { [weak self] (error: Error?) in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                    self?.notificationManager.sendNotification(task: newTask)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            }
        case .edit?: do {
            let newTask = Task(id: (selectedTask?.id)!, details: taskTextField.text!, subject: subjectTextField.text!, finishTime: datePicker.date, remindTime: Calendar.current.date(byAdding: .minute, value: 0, to: datePicker.date)!, isDone: finishSwitch.isOn, note: noteTextView.text!, photo: UIImage(named: "") ?? nil)
            if newTask.details == "" {
                self.present(alertController, animated: true, completion: nil)
            } else {
                DataSource.shared.updateTask(newTask) { [weak self] (error: Error?) in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                    self?.notificationManager.editNotification(task: newTask)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            }
        case .none:
            debugPrint("none")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }

}
