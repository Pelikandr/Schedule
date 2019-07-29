//
//  SchedulesAdapter.swift
//  Shedule
//
//  Created by Maria Holubieva on 29.07.2019.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class SchedulesAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {

    var sections = [Section]()

    var onDelete: ((Subject, IndexPath) -> Void)?
    var onSubjectSelected: ((Subject) -> Void)?
    
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

    func tableView(_ tablewView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSubjectSelected?(sections[indexPath.section].list[indexPath.row])
    }

    func tableView(_ tablewView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subject: Subject = sections[indexPath.section].list[indexPath.row]

        let cell = tablewView.dequeueReusableCell(withIdentifier: "SheduleCell", for: indexPath) as! SheduleCell
        cell.subjectNameLabel.text = subject.subjectName
        cell.classroomTypeLabel.text = subject.classroom + ", " + subject.classType
        cell.startTimeLabel.text = subject.startTime
        cell.endTimeLabel.text = subject.endTime
        cell.proffesorNameLabel.text = subject.proffesorName
        cell.separatorView.backgroundColor = subject.separatorColor
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Change") { [weak self] (action, indexPath) -> Void in
            //TODO: seague
            guard let self = self else { return }
            let _: Subject = self.sections[indexPath.section].list[indexPath.row]
        }
        editAction.backgroundColor = UIColor.orange

        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Delete") { [weak self] (action, indexPath) -> Void in
            guard let self = self else { return }
            self.onDelete?(self.sections[indexPath.section].list[indexPath.row], indexPath)
        }
        return [deleteAction, editAction]
    }
}
