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

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
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
        }
    }
    
    @objc func editItemAction() {
        delegate?.itemTableViewCellEditAction(cell: self)
    }
    
    @objc func deleteAction() {
        delegate?.itemTableViewCellDeleteAction(cell: self)
    }
    
    func configure(indexPath: IndexPath, delegate: ItemTableViewCellDelegate?) {
        self.indexPath = indexPath
        self.delegate = delegate
    }
}
