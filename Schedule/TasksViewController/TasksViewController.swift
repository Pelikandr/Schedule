//
//  SecondViewController.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/25/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let adapter = TasksAdapter()
    
    var condition: DetailCondition?
    var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.delegate = adapter
        tableView.dataSource = adapter
        
        adapter.onTaskSelected = { (task: Task) in
            self.selectedTask = task
            self.condition = .edit
            self.performSegue(withIdentifier: "toTasksDetail", sender: nil)
        }
        
        adapter.onDelete = { [weak wDataSource = DataSource.shared] (task: Task, indexPath: IndexPath) in
            wDataSource?.removeTask(task: task) { [weak self] (error: Error?) in
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
        DataSource.shared.getTasksList { [weak self] (sectionsList, error) in
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
        self.condition = .add
        self.performSegue(withIdentifier: "toTasksDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC = segue.destination as? TasksDetailTableViewController else { return }
        nextVC.condition = condition
        nextVC.selectedTask = selectedTask
    }

}


