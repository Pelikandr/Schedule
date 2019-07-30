//
//  SecondViewController.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/25/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class Tasks: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "In progress" }
        if section == 1 { return "Done" }
        else { return " " }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.shared.tasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TasksCell
        let task = DataSource.shared.tasksList[indexPath.row]
        cell.detailLabel.text = task.details
        cell.subjectLabel.text = task.subject
        cell.finishTimeLabel.text = dateString(task.finishTime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    lazy var dateFormatter = DateFormatter()
    private func dateString(_ date: Date) -> String {
        dateFormatter.dateFormat = "E, dd.MM"
        return dateFormatter.string(from: date)
    }


}


