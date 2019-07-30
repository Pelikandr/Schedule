//
//  TasksDetail.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/27/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class TasksDetail: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func inProgress(_ sender: Any) {
        let task = Task(details: "lab2", subject: "English", finishTime: Date(), remindTime: Date(), isDone: true, note: "kkk kkk kkk")
        DataSource.shared.appendTask(task: task)
    }
    
    @IBAction func done(_ sender: Any) {
        let task = Task(details: "lab2", subject: "English", finishTime: Date(), remindTime: Date(), isDone: false, note: "kkk kkk kkk")
        DataSource.shared.appendTask(task: task)
    }

}
