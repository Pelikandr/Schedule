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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablewView.rowHeight = 70
        tablewView.delegate = self as UITableViewDelegate
        tablewView.dataSource = self
        //DataSource.shared.testAppend()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tablewView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataSource.shared.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DataSource.shared.sectionList[section].weekDayName
    }
    
    
    func tableView(_ sheduleTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.shared.sectionList[section].subjectList.count
    }
    
    func tableView(_ sheduleTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ sheduleTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sheduleTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SheduleCell
        let subject: Subject = DataSource.shared.sectionList[indexPath.section].subjectList[indexPath.row]
        cell.subjectNameLabel.text = subject.subjectName
        cell.classroomTypeLabel.text = subject.classroom + ", " + subject.type
        cell.startTimeLabel.text = timeString(subject.startTime)
        cell.endTimeLabel.text = timeString(subject.endTime)
        cell.proffesorNameLabel.text = subject.proffesorName
        cell.separatorView.backgroundColor = subject.separatorColor
        return cell
    }
    
    
    
    @IBAction func addButton(_ sender: Any) {
        toSheduleDetail()
    }
    
    func toSheduleDetail() {
        self.performSegue(withIdentifier: "toSheduleDetail", sender: nil)
    }

    private lazy var dateFormatter = DateFormatter()
    private func dayString(_ date: Date) -> String {
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: date)
    }
    private func timeString(_ date: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func check(arr: [Subject]) {
        
    }
}

