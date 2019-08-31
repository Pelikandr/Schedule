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

struct taskSection {
    let name: String
    var list: [Task]
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
    let id: String
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
    
    var separatorColor = UIColor.darkGray
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ScheduleModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

//    func appendTask(task: Task) {
//        tasksList.append(task)
//    }
    
    func getSubjectList(weekNumber: Int, completion: @escaping (([Section]?, Error?) -> Void)) {
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

                        if base.weekNumber == Int16(weekNumber) {
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
                        } else { return nil }
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
    
    func updateSubject(_ subject: Subject, completion: ((Error?) -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            
            let managedContext = self.persistentContainer.newBackgroundContext()
            
            let request = NSFetchRequest<BaseSubject>(entityName: "BaseSubject")
            request.predicate = NSPredicate(format: "id == [c] %@", subject.id)
            do {
                if let baseSubject = try managedContext.fetch(request).first {
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
                    try managedContext.save()
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                } else { print("error") }
            } catch {
                DispatchQueue.main.async {
                    completion?(error)
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

    func getTasksList(completion: @escaping (([taskSection]?, Error?) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            
            do {
                let tasks = try self.persistentContainer.viewContext
                    .fetch(NSFetchRequest<BaseTask>(entityName: "BaseTask"))
                    .sorted(by: { ($0.finishTime ?? Date()) < ($1.finishTime ?? Date()) })
                    .compactMap({ (base: BaseTask) -> Task? in
                        guard let id = base.id,
                            let details = base.details,
                            let subject = base.subject,
                            let finishTime = base.finishTime,
                            let remindTime = base.remindTime,
                            let isDone = base.isDone as Bool?,
                            let note = base.note else { return nil }
                        
                        return Task(id: id,
                                    details: details,
                                    subject: subject,
                                    finishTime: finishTime,
                                    remindTime: remindTime,
                                    isDone: isDone,
                                    note: note )
                    })
                var sections = [taskSection]()
                if let isDone = false as Bool?{
                    sections.append(taskSection(name: "In progress", list: tasks.filter({ $0.isDone == isDone })))
                    }
                if let isDone = true as Bool?{
                    sections.append(taskSection(name: "Done", list: tasks.filter({ $0.isDone == isDone })))
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
    
    func appendTask(task: Task, completion: ((Error?) -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            
            let managedContext = self.persistentContainer.newBackgroundContext()
            
            let baseTask = BaseTask(context: managedContext)
            baseTask.id = task.id
            baseTask.details = task.details
            baseTask.subject = task.subject
            baseTask.finishTime = task.finishTime
            baseTask.remindTime = task.remindTime
            baseTask.isDone = task.isDone
            baseTask.note = task.note
            
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
    
    func removeTask(task: Task, completion: ((Error?) -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            
            let managedContext = self.persistentContainer.newBackgroundContext()
            
            let request = NSFetchRequest<BaseTask>(entityName: "BaseTask")
            request.predicate = NSPredicate(format: "id == [c] %@", task.id)
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
}
