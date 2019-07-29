//
//  FirstViewController.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/25/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit


class Shedule: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tablewView: UITableView!
    
    var sectionList = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablewView.rowHeight = 70
        tablewView.delegate = self as UITableViewDelegate
        tablewView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
        tablewView.reloadData()
    }
    
    func reloadView() {
        
        DataSource.shared.getSubjectList{ [weak self] (subjectList, error) in
            if let error = error {
                print(error)
            } else {
                //DataSource.shared.sheduleSectionList[(subject?.weekNumber)!].list.append(subjectList!)
                DataSource.shared.subjectList = subjectList!
                self!.tablewView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataSource.shared.sheduleSectionList.count
    }
    
    func tableView(_ tablewView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.shared.sheduleSectionList[section].list.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if DataSource.shared.sheduleSectionList[section].list.isEmpty {
            return nil
        } else {
            return DataSource.shared.sheduleSectionList[section].name + ", " + dayString(Date())
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func tableView(_ tablewView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tablewView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablewView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SheduleCell
        let subject: Subject = DataSource.shared.sheduleSectionList[indexPath.section].list[indexPath.row]
        cell.subjectNameLabel.text = subject.subjectName
        cell.classroomTypeLabel.text = subject.classroom + ", " + subject.classType
        cell.startTimeLabel.text = timeString(subject.startTime)
        cell.endTimeLabel.text = timeString(subject.endTime)
        cell.proffesorNameLabel.text = subject.proffesorName
        cell.separatorView.backgroundColor = subject.separatorColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Change") { [weak self] (action, indexPath) -> Void in
            let subject: Subject? = DataSource.shared.sheduleSectionList[indexPath.section].list[indexPath.row]
            //seague
        }
        editAction.backgroundColor = UIColor.orange
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Delete") { [weak self] (action, indexPath) -> Void in
            if let subject = DataSource.shared.sheduleSectionList[indexPath.section].list[indexPath.row] as? Subject {
                DataSource.shared.removeSubject(subject: subject) { [weak self] (error: Error?) in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    } else {
                        // TODO: сделать массив хранения предметов в классе Shedule
                        DataSource.shared.subjectList.remove(at: indexPath.row)
                        self!.tablewView.deleteRows(at: [indexPath], with: .fade)
                        
                        }
                    }
                }
            }
        return [deleteAction, editAction]
    }
    
    @IBAction func addButton(_ sender: Any) {
        toSheduleDetail()
    }
    
    func toSheduleDetail() {
        self.performSegue(withIdentifier: "toSheduleDetail", sender: nil)
    }

    lazy var dateFormatter = DateFormatter()
    private func dayString(_ date: Date) -> String {
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter.string(from: date)
    }
    private func timeString(_ date: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

