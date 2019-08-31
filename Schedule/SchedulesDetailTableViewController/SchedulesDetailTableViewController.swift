//
//  SchedulesDetailTableViewController.swift
//  Schedule
//
//  Created by Denis Zayakin on 7/29/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

enum ScheduleDetailCondition {
    case add
    case edit
}

class SchedulesDetailTableViewController: UITableViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var classroomTextField: UITextField!
    
    @IBOutlet weak var classTypeTextField: UITextField!
    @IBOutlet weak var proffesorNameTextField: UITextField!
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var notePlaceholderLabel: UILabel!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var weekDayPicker: UIPickerView!
    
    var selectedSubject: Subject?
    var condition: ScheduleDetailCondition?
    var testSubject: Subject?
    
    var pickerData: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    var weekDay: WeekDay?
    var weekNumber: Int?
    var separatorColor: UIColor?

    private lazy var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        noteTextView.delegate = self
        
        self.weekDayPicker.delegate = self as UIPickerViewDelegate
        self.weekDayPicker.dataSource = self as UIPickerViewDataSource
        
        weekDayPicker.selectRow(0, inComponent: 0, animated: true)

        switch condition {
        case .add?: do {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
            weekDay = .monday
            }
        case .edit?: do {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(saveButton))
            weekDay = selectedSubject?.weekDay
            testSubject = selectedSubject
            subjectNameTextField.text = selectedSubject?.subjectName
            classroomTextField.text = selectedSubject?.classroom
            timePicker.date = (selectedSubject?.startTime)!
            weekDayPicker.selectRow(selectedSubject!.weekDay.rawValue, inComponent: 0, animated: true)
            proffesorNameTextField.text = selectedSubject?.proffesorName
            classTypeTextField.text = selectedSubject?.classType
            noteTextView.text = selectedSubject?.note
            }
        case .none:
            debugPrint("none")
        }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        swipeDown.delegate = self as! UIGestureRecognizerDelegate
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        self.tableView.addGestureRecognizer(swipeDown)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weekDay = WeekDay(rawValue: pickerView.selectedRow(inComponent: component))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0  { notePlaceholderLabel.text = "" }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        switch condition {
        case .add?: do {
            testSubject = Subject(id: UUID().uuidString, subjectName: subjectNameTextField.text!, classroom: classroomTextField.text!, startTime: timePicker.date, endTime: timePicker.date.addingTimeInterval(4800) , remindTime: Date(), proffesorName: proffesorNameTextField.text!, classType: classTypeTextField.text!, note: noteTextView.text, weekNumber: weekNumber!, weekDay: weekDay!, separatorColor: DataSource.shared.separatorColor )
            DataSource.shared.appendSubject(subject: testSubject!) { [weak self] (error: Error?) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                self?.navigationController?.popViewController(animated: true)
            }
            }
        case .edit?: do {
            testSubject = Subject(id: (selectedSubject?.id)!, subjectName: subjectNameTextField.text!, classroom: classroomTextField.text!, startTime: timePicker.date, endTime: timePicker.date.addingTimeInterval(4800), remindTime: Date(), proffesorName: proffesorNameTextField.text!, classType: classTypeTextField.text!, note: noteTextView.text, weekNumber: weekNumber!,
                                  weekDay: weekDay!,
                                  separatorColor: DataSource.shared.separatorColor )
            DataSource.shared.updateSubject(testSubject!) { [weak self] (error: Error?) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                self?.navigationController?.popViewController(animated: true)
            }
            }
        case .none:
            debugPrint("none")
        }
        DataSource.shared.separatorColor = UIColor.darkGray
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
}

