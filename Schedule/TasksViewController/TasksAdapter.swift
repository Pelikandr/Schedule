//
//  TasksAdapter.swift
//  Shedule
//
//  Created by Denis Zayakin on 8/2/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class TasksAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    lazy var dateFormatter = DateFormatter()
    
    var sections = [taskSection]()
    
    var onDelete: ((Task, IndexPath) -> Void)?
    var onTaskSelected: ((Task) -> Void)?
    let notificationManager = NotificationManager()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tablewView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].list.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections[section].list.isEmpty {
            return nil
        } else {
            return sections[section].name
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onTaskSelected?(sections[indexPath.section].list[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task: Task = sections[indexPath.section].list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TasksCell
        cell.detailLabel.text = task.details
        cell.subjectLabel.text = task.subject
        cell.finishTimeLabel.text = dateString(task.finishTime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Delete") { [weak self] (action, indexPath) -> Void in
            guard let self = self else { return }
            self.onDelete?(self.sections[indexPath.section].list[indexPath.row], indexPath)
            self.notificationManager.editNotification(task: self.sections[indexPath.section].list[indexPath.row])
            //TODO: delete notifications with cell
            self.notificationManager.deleteNotification(task: self.sections[indexPath.section].list[indexPath.row])
            
        }
        return [deleteAction]
    }
    
    //MARK: - Private
    private func dateString(_ date: Date) -> String {
        dateFormatter.dateFormat = "E, dd.MM"
        return dateFormatter.string(from: date)
    }
}
