//
//  ColorCell.swift
//  Schedule
//
//  Created by Denis Zayakin on 7/29/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class ColorChoiceCell: UITableViewCell {
    
    @IBOutlet var colorViews: [UIView]!
    @IBOutlet weak var choiceView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for view in colorViews {
            let tap = UITapGestureRecognizer(target: self, action:  #selector (self.chooseColor (_:)))
            view.addGestureRecognizer(tap)
            view.layer.cornerRadius = view.frame.width / 2.0
            choiceView.layer.cornerRadius = choiceView.frame.width / 2.0
        }
    }
    let schedulesDetailTableViewController = SchedulesDetailTableViewController()
    
    @objc func chooseColor(_ sender: UITapGestureRecognizer){
        var separatorColor: UIColor = (sender.view?.backgroundColor)!
        let borderWidth = CGFloat(integerLiteral: 4)
        choiceView.frame.origin.x = (sender.view?.frame.origin.x)! - borderWidth
        choiceView.frame.origin.y = (sender.view?.frame.origin.y)! - borderWidth
        schedulesDetailTableViewController.separatorColor = separatorColor
    }
}
