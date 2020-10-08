//
//  ViewController.swift
//  Deadline
//
//  Created by April Yang on 2020/10/8.
//

import UIKit

class MissionController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    lazy var dateFormatter: DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    func render() {
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
    }
    
    
    @IBAction func addMission(_ sender: Any) {
        editItem(indexPath: nil, done: nil)
    }
    
    func editItem(indexPath: IndexPath?, done:((Bool)->())?) {
        
        print("edit-->\(indexPath)")
        
        showAlertWith(mission: nil, date: Date())
        
        done?(true)
    }
    
    func deleteItem(indexPath: IndexPath, done:((Bool)->())?) {
        
        print("delete-->\(indexPath)")
        
        done?(true)
    }
    
    func showAlertWith(mission: String?, date: Date?) {
        
        let alert = UIAlertController(title: "edit", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "mission"
            textField.text = mission
        }
        
        alert.addAction(UIAlertAction(title: date==nil ? "" : dateFormatter.string(from: date!), style: .default, handler: { (action) in
            
            self.showDatePicker(currentDate: date) { (date) in
                self.showAlertWith(mission: alert.textFields?.first?.text, date: date)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if let mission = alert.textFields?.first?.text {
                print("add mission ---> \(mission)")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        

        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showDatePicker(currentDate: Date?, done:@escaping ((Date)->())) {
        
        DatePickerViewController.presentFrom(viewController: self, currentDate: currentDate, handler: done)
    }
}

extension MissionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textcellId", for: indexPath) as! ItemTableViewCell
        cell.configure(indexPath: indexPath, delegate: self)
        return cell
    }
}

extension MissionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .normal, title: "edit", handler: { (_, _, done) in
            self.editItem(indexPath: indexPath, done: done)
        })])
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "delete", handler: { (_, _, done) in
            self.deleteItem(indexPath: indexPath, done: done)
        })])
    }
}

extension MissionController: ItemTableViewCellDelegate{
    
    func itemTableViewCellEditAction(cell: ItemTableViewCell) {
        editItem(indexPath: cell.indexPath, done: nil)
    }
    
    func itemTableViewCellDeleteAction(cell: ItemTableViewCell) {
        deleteItem(indexPath: cell.indexPath, done: nil)
    }
}
