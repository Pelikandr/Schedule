//
//  DataSource.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/25/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import Foundation
import UIKit

struct Subject {
    var subjectName: String
    let classroom: String
    let startTime: Date
    let endTime: Date
    let remindTime: Date
    let proffesorName: String
    let type: String
    let note: String
    let week: Int
    let separatorColor: UIColor
}

class DataSource {
    
    static var shared = DataSource()
    
    var subjectList: [Subject] = []
    
    func append (subject: Subject) {
        subjectList.append(subject)
    }
    
    func testAppend() {
        let testSubject = Subject(subjectName: "ММДС", classroom: "6.302", startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: "Полухин А. В.", type: "Lection", note: "бла бла бла...", week: 1, separatorColor: UIColor.lightGray)
        append(subject: testSubject)
    }

}

