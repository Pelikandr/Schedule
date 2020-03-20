//
//  TasksDetailTableViewController.swift
//  Shedule
//
//  Created by Denis Zayakin on 8/30/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD

class TasksDetailTableViewController: UITableViewController, UITextViewDelegate, UIGestureRecognizerDelegate, UNUserNotificationCenterDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!

    @IBOutlet weak var finishSwitch: UISwitch!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var notePlaceholderLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    var condition: DetailCondition?
    var selectedTask: Task?
    
    let notificationManager = NotificationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        noteTextView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        pictureImageView.isUserInteractionEnabled = true
        pictureImageView.addGestureRecognizer(tapGestureRecognizer)
        
        switch condition {
        case .add?: do {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
            }
        case .edit?: do {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(saveButton))
            if noteTextView.text != nil  { notePlaceholderLabel.text = "" }
            taskTextField.text = selectedTask?.details
            subjectTextField.text = (selectedTask?.subject)!
            datePicker.date = (selectedTask?.finishTime)!
            finishSwitch.isOn = (selectedTask?.isDone)!
            noteTextView.text = (selectedTask?.note)!
            if noteTextView.text!.count == 0 { notePlaceholderLabel.text = "Note" }
            if let photo = selectedTask?.photo {
                print("PHOTO: \(photo)")
                pictureImageView.image = UIImage(data: photo)
            } else {
                pictureImageView.image = nil
            }
            }
        case .none:
            debugPrint("none")
        }

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        self.tableView.addGestureRecognizer(swipeDown)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("tapped")
        let alert = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        self.present(alert, animated: true) {
            self.tapRecognizer(alert: alert)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            SVProgressHUD.showError(withStatus: "You don't have permission to access gallery")
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            SVProgressHUD.showError(withStatus: "You don't have permission to access camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            pictureImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            pictureImageView.image = originalImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    //
    //        dismiss(animated: true, completion: nil)
    //
    //
    //    }
    
    func tapRecognizer(alert: UIAlertController) {
        alert.view.superview?.subviews.first?.isUserInteractionEnabled = true
        alert.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
    }
    
    @objc func actionSheetBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0  { notePlaceholderLabel.text = "" }
        if textView.text.count == 0 { notePlaceholderLabel.text = "Note" }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Error", message:
            "Enter task", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        switch condition {
        case .add?: do {
            let newTask = Task(id: UUID().uuidString, details: taskTextField.text!, subject: subjectTextField.text!, finishTime: datePicker.date, remindTime: Calendar.current.date(byAdding: .minute, value: 0, to: datePicker.date)!, isDone: finishSwitch.isOn, note: noteTextView.text!, photo: pictureImageView.image?.pngData())
            if newTask.details == "" {
                self.present(alertController, animated: true, completion: nil)
            } else {
                DataSource.shared.appendTask(task: newTask) { [weak self] (error: Error?) in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                    self?.notificationManager.sendNotification(task: newTask)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            }
        case .edit?: do {
            let newTask = Task(id: (selectedTask?.id)!, details: taskTextField.text!, subject: subjectTextField.text!, finishTime: datePicker.date, remindTime: Calendar.current.date(byAdding: .minute, value: 0, to: datePicker.date)!, isDone: finishSwitch.isOn, note: noteTextView.text!, photo: pictureImageView.image?.pngData())
            if newTask.details == "" {
                self.present(alertController, animated: true, completion: nil)
            } else {
                DataSource.shared.updateTask(newTask) { [weak self] (error: Error?) in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                    self?.notificationManager.editNotification(task: newTask)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            }
        case .none:
            debugPrint("none")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }

}
