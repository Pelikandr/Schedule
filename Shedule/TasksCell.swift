//
//  TasksCell.swift
//  Shedule
//
//  Created by Denis Zayakin on 7/27/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class TasksCell: UITableViewCell {

    
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        detailLabel.text = nil
        subjectLabel.text = nil
        finishTimeLabel.text = nil
    }

}
