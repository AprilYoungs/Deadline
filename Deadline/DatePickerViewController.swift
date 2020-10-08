//
//  DatePickerViewController.swift
//  Deadline
//
//  Created by April Yang on 2020/10/8.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    
    // MARK: variables
    var currentDate: Date?
    var handler: ((Date)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.date = currentDate ?? Date()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        handler?(self.datePicker.date)
        
        dismiss()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        handler?(self.datePicker.date)
        
        dismiss()
    }
    
    func dismiss() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    static func presentFrom(viewController: UIViewController, currentDate:Date?, handler: ((Date)->())?) {
        
        let datePicker = DatePickerViewController()
        datePicker.currentDate = currentDate
        viewController.addChild(datePicker)
        datePicker.view.frame = viewController.view.bounds
        viewController.view.addSubview(datePicker.view)
        datePicker.handler = handler
    }
    
}
