//
//  ItemTableViewCell.swift
//  Deadline
//
//  Created by April Yang on 2020/10/8.
//

import UIKit

protocol ItemTableViewCellDelegate: NSObjectProtocol {
    func itemTableViewCellEditAction(cell: ItemTableViewCell)
    func itemTableViewCellDeleteAction(cell: ItemTableViewCell)
}

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var missionLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet var deleteButtonWidth: NSLayoutConstraint!
    @IBOutlet var editButtonWidth: NSLayoutConstraint!
    // MARK: - variables
    weak var delegate: ItemTableViewCellDelegate?
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIDevice.current.systemName == "Mac OS X" {
            editButton.imageView?.contentMode = .scaleAspectFit
            deleteButton.imageView?.contentMode = .scaleAspectFit
            
            self.editButton.addTarget(self, action: #selector(editItemAction), for: .touchUpInside)
            self.deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        } else {
            self.editButton.isHidden = true
            self.deleteButton.isHidden = true
            self.editButtonWidth.constant = 0
            self.deleteButtonWidth.constant = 0
        }
    }
    
    @objc func editItemAction() {
        delegate?.itemTableViewCellEditAction(cell: self)
    }
    
    @objc func deleteAction() {
        delegate?.itemTableViewCellDeleteAction(cell: self)
    }
    
    func configure(item: DeadlineItem, indexPath: IndexPath, delegate: ItemTableViewCellDelegate?) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        if let date = item.date {
            let (timeLeftStr, exceed) = timeLeftTransfer(date: date)
            self.timeLabel.text = timeLeftStr
            self.timeLabel.textColor = exceed ? UIColor.red : UIColor.label
            
            self.missionLabel?.text = "\(item.mission ?? "") - \(DeadlineDataManager.dateFormatter.string(from: date))"
        } else {
            self.timeLabel.text = "Mission without a date"
            self.timeLabel.textColor = UIColor.red
            self.missionLabel.text = item.mission
        }
    }
}
