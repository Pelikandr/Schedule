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
        let testSubject = Subject(id: UUID().uuidString, subjectName: "ММДС", classroom: "6.302", startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: "Полухин А. В.", classType: "Lection", note: "бла бла бла...", weekNumber: 1, dayNumber: 0, separatorColor: UIColor.green)
        DataSource.shared.appendSubject(subject: testSubject) { (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func tue(_ sender: Any) {
        let testSubject = Subject(id: UUID().uuidString, subjectName: "ММДС", classroom: "6.302", startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: "Полухин А. В.", classType: "Lection", note: "бла бла бла...", weekNumber: 1, dayNumber: 1, separatorColor: UIColor.red)
        DataSource.shared.appendSubject(subject: testSubject) { (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func wed(_ sender: Any) {
        let testSubject = Subject(id: UUID().uuidString, subjectName: "ММДС", classroom: "6.302", startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: "Полухин А. В.", classType: "Lection", note: "бла бла бла...", weekNumber: 1, dayNumber: 2, separatorColor: UIColor.lightGray)
        DataSource.shared.appendSubject(subject: testSubject) { (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func thu(_ sender: Any) {
        let testSubject = Subject(id: UUID().uuidString, subjectName: "ММДС", classroom: "6.302", startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: "Полухин А. В.", classType: "Lection", note: "бла бла бла...", weekNumber: 1, dayNumber: 3, separatorColor: UIColor.blue)
        DataSource.shared.appendSubject(subject: testSubject) { (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
}
