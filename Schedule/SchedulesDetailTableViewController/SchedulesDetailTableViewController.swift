//
//  SchedulesDetailTableViewController.swift
//  Schedule
//
//  Created by Denis Zayakin on 7/29/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class SchedulesDetailTableViewController: UITableViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var classroomTextField: UITextField!
    
    @IBOutlet weak var classTypeTextField: UITextField!
    @IBOutlet weak var proffesorNameTextField: UITextField!
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var notePlaceholderLabel: UILabel!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var weekDayPicker: UIPickerView!
    var pickerData: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    var weekDay: WeekDay?
    var weekNumber: Int?
    private lazy var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        
        self.weekDayPicker.delegate = self as UIPickerViewDelegate
        self.weekDayPicker.dataSource = self as UIPickerViewDataSource
        
        weekDayPicker.selectRow(0, inComponent: 0, animated: true)
        weekDay = .monday
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
        
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
        // TODO: selection of weekNumber
        //let separatorColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        let testSubject = Subject(id: UUID().uuidString, subjectName: subjectNameTextField.text!, classroom: classroomTextField.text!, startTime: timePicker.date, endTime: timePicker.date.addingTimeInterval(4800) , remindTime: Date(), proffesorName: proffesorNameTextField.text!, classType: classTypeTextField.text!, note: noteTextView.text, weekNumber: weekNumber!, weekDay: weekDay!, separatorColor: DataSource.shared.separatorColor )
        DataSource.shared.appendSubject(subject: testSubject) { [weak self] (error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            self?.navigationController?.popViewController(animated: true)
        }
        DataSource.shared.separatorColor = UIColor.darkGray
    }
    private func prettyDate(_ date: Date) -> String {
        dateFormatter.dateFormat = "dd MMMM, HH:mm"
        return dateFormatter.string(from: date)
    }
    private func timeString(_ date: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
    
}

