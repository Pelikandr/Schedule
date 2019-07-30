//
//  SheduleDetail.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/25/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class SheduleDetail: UIViewController {
    
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
    
    @IBAction func tue(_ sender: Any) {
        let testSubject = DataSource.shared.getSubject(for: .tuesday, color: .blue)
        DataSource.shared.appendSubject(subject: testSubject) { [weak self] (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func wed(_ sender: Any) {
        let testSubject = DataSource.shared.getSubject(for: .wednesday, color: .green)
        DataSource.shared.appendSubject(subject: testSubject) { [weak self] (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func thu(_ sender: Any) {
        let testSubject = DataSource.shared.getSubject(for: .thursday, color: .yellow)
        DataSource.shared.appendSubject(subject: testSubject) { [weak self] (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
