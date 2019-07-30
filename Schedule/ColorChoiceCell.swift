//
//  ColorCell.swift
//  Schedule
//
//  Created by Denis Zayakin on 7/29/19.
//  Copyright © 2019 Denis Zayakin. All rights reserved.
//

import UIKit

class ColorCell: UITableViewCell {
    
    @IBOutlet var colorViews: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0..<colorViews.count {
            let tap = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
            colorViews[i].addGestureRecognizer(tap)
            colorViews[i].layer.cornerRadius = 12
            colorViews[i].layer.borderWidth = 2
            colorViews[i].layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    @objc func someAction(_ sender: UITapGestureRecognizer){
        //let color: UIColor = (sender.view?.backgroundColor)!
        for i in 0..<colorViews.count {
            colorViews[i].layer.cornerRadius = 12
            colorViews[i].layer.borderWidth = 2
            colorViews[i].layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        sender.view?.layer.borderWidth = 3
        sender.view?.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}
