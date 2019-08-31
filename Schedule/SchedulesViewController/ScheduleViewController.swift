//
//  ScheduleViewController.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/25/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weekControl: UISegmentedControl!
    
    private let adapter = SchedulesAdapter()
    
    var weekNumber: Int = 1
    var condition: ScheduleDetailCondition?
    var selectedSubject: Subject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        
        tableView.delegate = adapter
        tableView.dataSource = adapter
        
        adapter.onSubjectSelected = { (subject: Subject) in
            self.selectedSubject = subject
            self.condition = .edit
            self.performSegue(withIdentifier: "toSheduleDetail", sender: nil)
        }

        adapter.onDelete = { [weak wDataSource = DataSource.shared] (subject: Subject, indexPath: IndexPath) in
            wDataSource?.removeSubject(subject: subject) { [weak self] (error: Error?) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                } else {
                    self?.reloadView()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
    }
    
    func reloadView(_ isTableViewReload: Bool = true, completion: (() -> Void)? = nil) {
        DataSource.shared.getSubjectList(weekNumber: weekNumber) { [weak self] (sectionsList, error) in
            if let error = error {
                print(error)
            } else if let sectionsList = sectionsList {
                self?.adapter.sections = sectionsList
                if isTableViewReload {
                    self?.tableView.reloadData()
                }
                completion?()
            }
        }
    }
    

    @IBAction func weekChanged(_ sender: UISegmentedControl) {
        switch weekControl.selectedSegmentIndex
        {
        case 0:
            weekNumber = 1
            reloadView()
        case 1:
            weekNumber = 2
            reloadView()
        default:
            break
        }
    }
    
    @IBAction func onAdd(_ sender: Any) {
        self.condition = .add
        self.performSegue(withIdentifier: "toSheduleDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC = segue.destination as? SchedulesDetailTableViewController else { return }
        nextVC.weekNumber = weekNumber
        nextVC.condition = condition!
        nextVC.selectedSubject = selectedSubject
    }
}

