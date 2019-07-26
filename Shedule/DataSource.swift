//
//  DataSource.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/25/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import Foundation
import UIKit

enum weekDays {
    case monday
    case tuesday
//    case wednesday
//    case thursday
//    case friday
//    case sunday
}

struct Section {
    let weekDayName: String
    var subjectList: [Subject]
}

struct Subject {
    var subjectName: String
    let classroom: String
    let startTime: Date
    let endTime: Date
    let remindTime: Date
    let proffesorName: String
    let type: String
    let note: String
    let weekNumber: Int
    let weekDay: Int
    let separatorColor: UIColor
}

class DataSource {
    
    static var shared = DataSource()

    var subjectList: [Subject] = []
    lazy var  monday = Section(weekDayName: "Monday", subjectList: subjectList)
    lazy var tuesday = Section(weekDayName: "Tuesday", subjectList: subjectList)
    lazy var wednesday = Section(weekDayName: "Wednesday", subjectList: subjectList)
    lazy var thursday = Section(weekDayName: "Thursday", subjectList: subjectList)
    lazy var friday = Section(weekDayName: "Friday", subjectList: subjectList)
    lazy var sunday = Section(weekDayName: "Sunday", subjectList: subjectList)
    lazy var sectionList: [Section] = [monday, tuesday, wednesday, thursday, friday, sunday]
    
    var sectionHeaderList = [0: "Monday", 1: "Tuesday", 2: "Wednesday", 3: "Thursday", 4: "Friday", 5: "Sunday"]
    
    func append(subject: Subject) {
        subjectList.append(subject)
        sectionList[subject.weekDay].subjectList.append(subject)
    }

    func testAppend() {
        let testSubject = Subject(subjectName: "ММДС", classroom: "6.302", startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: "Полухин А. В.", type: "Lection", note: "бла бла бла...", weekNumber: 1, weekDay: 0, separatorColor: UIColor.lightGray)
        append(subject: testSubject)
    }
}



