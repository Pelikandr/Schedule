//
//  ClassCell.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/25/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class SheduleCell: UITableViewCell {
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var classroomTypeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var proffesorNameLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subjectNameLabel.text = nil
        classroomTypeLabel.text = nil
        startTimeLabel.text = nil
        endTimeLabel.text = nil
        proffesorNameLabel.text = nil
    }

}
