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
        let testSubject = Subject(subjectName: "ММДС", classroom: "6.302", startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: "Полухин А. В.", type: "Lection", note: "бла бла бла...", week: 1, separatorColor: UIColor.green)
        DataSource.shared.append(subject: testSubject)
    }
}
