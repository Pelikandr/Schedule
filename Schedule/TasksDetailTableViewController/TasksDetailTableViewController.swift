//
//  TasksDetailTableViewController.swift
//  Shedule
//
//  Created by Denis Zayakin on 8/30/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class TasksDetailTableViewController: UITableViewController, UITextViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!

    @IBOutlet weak var finishSwitch: UISwitch!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var notePlaceholderLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        noteTextView.delegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        swipeDown.delegate = self as? UIGestureRecognizerDelegate
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        self.tableView.addGestureRecognizer(swipeDown)
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0  { notePlaceholderLabel.text = "" }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let task = Task(id: UUID().uuidString, details: taskTextField.text!, subject: subjectTextField.text!, finishTime: datePicker.date, remindTime: Date(), isDone: finishSwitch.isOn, note: noteTextView.text!)
        DataSource.shared.appendTask(task: task) { [weak self] (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }

}
