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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0  { notePlaceholderLabel.text = "" }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let testSubject = DataSource.shared.getSubject(for: .monday, color: .red)
        DataSource.shared.appendSubject(subject: testSubject) { [weak self] (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
