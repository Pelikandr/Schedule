//
//  DataSource.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/25/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Section {
    let name: String
    var list: [Subject]
}

struct Subject {
    let id: String
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
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SheduleModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var  monday = Section(name: "Monday", list: subjectList)
    lazy var tuesday = Section(name: "Tuesday", list: subjectList)
    lazy var wednesday = Section(name: "Wednesday", list: subjectList)
    lazy var thursday = Section(name: "Thursday", list: subjectList)
    lazy var friday = Section(name: "Friday", list: subjectList)
    lazy var saturday = Section(name: "Saturday", list: subjectList)
    lazy var sunday = Section(name: "Sunday", list: subjectList)
    
    lazy var sheduleSectionList: [Section] = [monday, tuesday, wednesday, thursday, friday, sunday]
    
    var sectionHeaderList = [0: "Monday", 1: "Tuesday", 2: "Wednesday", 3: "Thursday", 4: "Friday", 5: "Saturday", 6: "Sunday"]
    
    func appendTask(task: Task) {
        taskList.append(task)
    }
    
    func getSubjectList(completion: @escaping (([Subject]?, Error?) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let shedule =  try self.persistentContainer.viewContext
                    .fetch(NSFetchRequest<BaseSubject>(entityName: "BaseSubject"))
                    .compactMap({ (base: BaseSubject) -> Subject? in
                        guard let id = base.id, let subjectName = base.subjectName, let classroom = base.classroom, let startTime = base.startTime, let endTime = base.endTime, let remindTime = base.remindTime, let proffesorName = base.proffesorName, let classType = base.classType, let note = base.note, let weekNumber = base.weekNumber as? Int16, let dayNumber = base.dayNumber as? Int16, let separatorColor = base.separatorColor else {
                            return nil
                        }
                        return Subject(id: id, subjectName: subjectName, classroom: classroom, startTime: startTime, endTime: endTime, remindTime: remindTime, proffesorName: proffesorName, classType: classType, note: note, weekNumber: Int(weekNumber), dayNumber: Int(dayNumber), separatorColor: separatorColor as! UIColor)
                    })
                
                DispatchQueue.main.async {
                    completion(shedule, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    

    
    func appendSubject(subject: Subject, completion: ((Error?) -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in guard let `self` = self else { return }
            
            let managedContext = self.persistentContainer.newBackgroundContext()
            
            let baseSubject = BaseSubject(context: managedContext)
            baseSubject.subjectName = subject.subjectName
            baseSubject.classroom = subject.classroom
            baseSubject.startTime = subject.startTime
            baseSubject.endTime = subject.endTime
            baseSubject.remindTime = subject.remindTime
            baseSubject.proffesorName = subject.proffesorName
            baseSubject.classType = subject.classType
            baseSubject.note = subject.note
            baseSubject.weekNumber = Int16(subject.weekNumber)
            baseSubject.dayNumber = Int16(subject.dayNumber)
            baseSubject.separatorColor = subject.separatorColor
            
            do {
                try managedContext.save()
                DispatchQueue.main.async {
                    completion?(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
            
        }
        //subjectList.append(subject)
        //sheduleSectionList[subject.dayNumber].list.append(subject)
    }
    
    func removeSubject(subject: Subject, completion: ((Error?) -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in guard let `self` = self else { return }
            
            let managedContext = self.persistentContainer.newBackgroundContext()
            
            let request = NSFetchRequest<BaseSubject>(entityName: "BaseSubject")
            request.predicate = NSPredicate(format: "id == [c] %@", subject.id)
            do {
                if let object = try managedContext.fetch(request).first {
                    managedContext.delete(object)
                    try managedContext.save()
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        }
    }

    func testAppend() {
        let testSubject = Subject(id: UUID().uuidString, subjectName: "ММДС", classroom: "6.302", startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: "Полухин А. В.", classType: "Lection", note: "бла бла бла...", weekNumber: 1, dayNumber: 0, separatorColor: UIColor.lightGray)
        appendSubject(subject: testSubject) { (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
}


//    func getSubjectList(completion: @escaping (([Subject]?, Error?) -> Void)) {
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            guard let `self` = self else { return }
//
//            do {
//                let shedule =  try self.persistentContainer.viewContext
//                    .fetch(NSFetchRequest<BaseSubject>(entityName: "BaseSubject"))
//                    .compactMap({ (base: BaseSubject) -> Subject? in
//                        guard let id = base.id, let subjectName = base.subjectName, let classroom = base.classroom, let startTime = base.startTime, let endTime = base.endTime, let remindTime = base.remindTime, let proffesorName = base.proffesorName, let classType = base.classType, let note = base.note, let weekNumber = base.weekNumber as? Int16, let dayNumber = base.dayNumber as? Int16, let separatorColor = base.separatorColor else {
//                            return nil
//                        }
//                        return Subject(id: id, subjectName: subjectName, classroom: classroom, startTime: startTime, endTime: endTime, remindTime: remindTime, proffesorName: proffesorName, classType: classType, note: note, weekNumber: Int(weekNumber), dayNumber: Int(dayNumber), separatorColor: separatorColor as! UIColor)
//                    })
//
//                DispatchQueue.main.async {
//                    completion(shedule, nil)
//                }
//
//            } catch {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//            }
//        }
//    }
