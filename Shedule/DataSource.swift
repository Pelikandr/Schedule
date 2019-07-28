//
//  DataSource.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/25/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import Foundation
import UIKit

struct Section {
    let name: String
    var list: [Subject]
}

struct Subject {
    var subjectName: String
    let classroom: String
    let startTime: Date
    let endTime: Date
    let remindTime: Date
    let proffesorName: String
    let classType: String
    let note: String
    let weekNumber: Int
    let dayNumber: Int // mon = 0, tue = 1 ...
    let separatorColor: UIColor
}

struct Task {
    let detail: String
    let subject: String
    let finishTime: Date
    let remindTime: Date
    let done: Bool
    let note: String
}

class DataSource {
    
    static var shared = DataSource()
    
    var taskList = [Task]()

    var subjectList = [Subject]()
    lazy var  monday = Section(name: "Monday", list: subjectList)
    lazy var tuesday = Section(name: "Tuesday", list: subjectList)
    lazy var wednesday = Section(name: "Wednesday", list: subjectList)
    lazy var thursday = Section(name: "Thursday", list: subjectList)
    lazy var friday = Section(name: "Friday", list: subjectList)
    lazy var sunday = Section(name: "Sunday", list: subjectList)
    lazy var sheduleSectionList: [Section] = [monday, tuesday, wednesday, thursday, friday, sunday]
    
    var sectionHeaderList = [0: "Monday", 1: "Tuesday", 2: "Wednesday", 3: "Thursday", 4: "Friday", 5: "Sunday"]
    
    func appendTask(task: Task) {
        taskList.append(task)
    }
    
    func appendSubject(subject: Subject) {
        subjectList.append(subject)
        sheduleSectionList[subject.dayNumber].list.append(subject)
    }

    func testAppend() {
        let testSubject = Subject(subjectName: "ММДС", classroom: "6.302", startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: "Полухин А. В.", classType: "Lection", note: "бла бла бла...", weekNumber: 1, dayNumber: 0, separatorColor: UIColor.lightGray)
        appendSubject(subject: testSubject)
    }
}



