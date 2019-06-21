//
//  ButtonTableViewCell.swift
//  Assessment2
//
//  Created by Leah Cluff on 6/21/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit

    class ButtonTableViewCell: UITableViewCell {
        
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var completeButton: UIButton!
        
        var delegate: ButtonTableViewCellDelegate?
        
         func updateButton(_ isComplete: Bool){
            let imageName = isComplete ? "complete" : "incomplete"
            completeButton.setImage(UIImage(named: imageName), for: .normal)
        }
        //MARK: - Button Actions
        @IBAction func buttonTapped(_ sender: Any) {
            delegate?.buttonCellButtonTapped(self)
        }
}
extension ButtonTableViewCell {
    func update(withList list: List) {
        nameLabel.text = list.item
        updateButton(!list.isComplete)
    }
}
//MARK: - Cell Protocol
protocol ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}
