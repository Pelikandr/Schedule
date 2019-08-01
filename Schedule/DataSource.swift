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

enum WeekDay: Int {
    case monday = 0
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var name: String {
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
}

struct Section {
    let name: String
    var list: [Subject]
}

struct Subject {
    let id: String
    let subjectName: String
    let classroom: String
    let startTime: Date
    let endTime: Date
    let remindTime: Date
    let proffesorName: String
    let classType: String
    let note: String
    let weekNumber: Int
    let weekDay: WeekDay
    let separatorColor: UIColor
}

struct Task {
    let details: String
    let subject: String
    let finishTime: Date
    let remindTime: Date
    let isDone: Bool
    let note: String
}

class DataSource {
    
    static var shared = DataSource()
    
    var tasksList = [Task]()
    
    var separatorColor = UIColor()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ScheduleModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func appendTask(task: Task) {
        tasksList.append(task)
    }
    
    func getSubjectList(completion: @escaping (([Section]?, Error?) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let subjects = try self.persistentContainer.viewContext
                    .fetch(NSFetchRequest<BaseSubject>(entityName: "BaseSubject"))
                    .sorted(by: { ($0.startTime ?? Date()) < ($1.startTime ?? Date()) })
                    .compactMap({ (base: BaseSubject) -> Subject? in
                        guard let id = base.id,
                            let subjectName = base.subjectName,
                            let classroom = base.classroom,
                            let startTime = base.startTime,
                            let endTime = base.endTime,
                            let remindTime = base.remindTime,
                            let proffesorName = base.proffesorName,
                            let classType = base.classType,
                            let note = base.note,
                            let weekDay = WeekDay(rawValue: Int(base.dayNumber)),
                            let separatorColor = base.separatorColor as? UIColor else { return nil }

                        return Subject(id: id,
                                       subjectName: subjectName,
                                       classroom: classroom,
                                       startTime: startTime,
                                       endTime: endTime,
                                       remindTime: remindTime,
                                       proffesorName: proffesorName,
                                       classType: classType,
                                       note: note,
                                       weekNumber: Int(base.weekNumber),
                                       weekDay: weekDay,
                                       separatorColor: separatorColor)
                    })

                var sections = [Section]()
                for i in 0..<7 {
                    if let day = WeekDay(rawValue: i) {
                        sections.append(Section(name: day.name, list: subjects.filter({ $0.weekDay == day })))
                    }
                }
                let filteredSections = sections.filter({ !$0.list.isEmpty })

                DispatchQueue.main.async {
                    completion(filteredSections, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func appendSubject(subject: Subject, completion: ((Error?) -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            
            let managedContext = self.persistentContainer.newBackgroundContext()
            
            let baseSubject = BaseSubject(context: managedContext)
            baseSubject.id = subject.id
            baseSubject.subjectName = subject.subjectName
            baseSubject.classroom = subject.classroom
            baseSubject.startTime = subject.startTime
            baseSubject.endTime = subject.endTime
            baseSubject.remindTime = subject.remindTime
            baseSubject.proffesorName = subject.proffesorName
            baseSubject.classType = subject.classType
            baseSubject.note = subject.note
            baseSubject.weekNumber = Int16(subject.weekNumber)
            baseSubject.dayNumber = Int16(subject.weekDay.rawValue)
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
    }
    
    func removeSubject(subject: Subject, completion: ((Error?) -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            
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

    func getSubject(for weekDay: WeekDay, color: UIColor) -> Subject {
        return Subject(id: UUID().uuidString, subjectName: "ММДС", classroom: "6.302", startTime: Date(), endTime: Date(), remindTime: Date(), proffesorName: "Полухин А. В.", classType: "Lection", note: "бла бла бла...", weekNumber: 1, weekDay: weekDay, separatorColor: color)
    }
}
