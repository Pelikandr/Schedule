//
//  SchedulesDetailTableViewController.swift
//  Schedule
//
//  Created by Denis Zayakin on 7/29/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class SchedulesDetailTableViewController: UITableViewController {


    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var classroomTextField: UITextField!
    
    @IBOutlet weak var classTypeTextField: UITextField!
    @IBOutlet weak var proffesorNameTextField: UITextField!
    
    @IBOutlet weak var noteTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
