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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.delegate = adapter
        tableView.dataSource = adapter

        adapter.onDelete = { [weak wDataSource = DataSource.shared] (subject: Subject, indexPath: IndexPath) in
            wDataSource?.removeSubject(subject: subject) { [weak self] (error: Error?) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                } else {
                    self?.reloadView()
                    //TODO: check if in section there will be no cells - call tableView.deleteSections method. Othervise - tableView.deleteRows
//                    self?.reloadView(false) { [weak self] in
//                        self?.tableView.deleteRows(at: [indexPath], with: .fade)
//                    }
//                    self?.tableView.deleteSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableView.RowAnimation#>)
                }
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
    
    @IBAction func onAdd(_ sender: Any) {
        self.performSegue(withIdentifier: "toSheduleDetail", sender: nil)
    }
    
}

