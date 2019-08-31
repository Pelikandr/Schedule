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
    
    let borderWidth = CGFloat(integerLiteral: 4)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for view in colorViews {
            let tap = UITapGestureRecognizer(target: self, action:  #selector (self.chooseColor (_:)))
            view.addGestureRecognizer(tap)
            view.layer.cornerRadius = view.frame.width / 2.0
            choiceView.layer.cornerRadius = choiceView.frame.width / 2.0
            if view.backgroundColor == DataSource.shared.separatorColor {
                choiceView.frame.origin.x = (view.frame.origin.x) - borderWidth
                choiceView.frame.origin.y = (view.frame.origin.y) - borderWidth
            } 
        }
    }
    
    @objc func chooseColor(_ sender: UITapGestureRecognizer){
        
        choiceView.frame.origin.x = (sender.view?.frame.origin.x)! - borderWidth
        choiceView.frame.origin.y = (sender.view?.frame.origin.y)! - borderWidth
        DataSource.shared.separatorColor = (sender.view?.backgroundColor)!
    }
}
