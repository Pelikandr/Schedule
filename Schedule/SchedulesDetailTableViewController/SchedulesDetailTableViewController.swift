//
//  SchedulesDetailTableViewController.swift
//  Schedule
//
//  Created by Denis Zayakin on 7/29/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class SchedulesDetailTableViewController: UITableViewController, UITextViewDelegate {
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var classroomTextField: UITextField!
    
    @IBOutlet weak var classTypeTextField: UITextField!
    @IBOutlet weak var proffesorNameTextField: UITextField!
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var notePlaceholderLabel: UILabel!
    
    var separatorColor = UIColor()
    
    private lazy var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0  { notePlaceholderLabel.text = "" }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        // TODO: selection of start and end time, weekNumber, weekday, separatorColor
        let testSubject = Subject(id: UUID().uuidString, subjectName: subjectNameTextField.text!, classroom: classroomTextField.text!, startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: proffesorNameTextField.text!, classType: classTypeTextField.text!, note: noteTextView.text, weekNumber: 1, weekDay: .monday, separatorColor: UIColor.red )
        DataSource.shared.appendSubject(subject: testSubject) { [weak self] (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    private func prettyDate(_ date: Date) -> String {
        dateFormatter.dateFormat = "dd MMMM, HH:mm"
        return dateFormatter.string(from: date)
    }
    private func timeString(_ date: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

