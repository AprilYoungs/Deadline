//
//  ViewController.swift
//  Deadline
//
//  Created by April Yang on 2020/10/8.
//

import UIKit

class MissionController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var missions: [DeadlineItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        loadData()
        DeadlineDataManager.instance.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadData),
            name: NSNotification.Name(
                rawValue: "NSPersistentStoreRemoteChangeNotification"),
                object: nil
        )
        
        if UIDevice.current.systemName == "Mac OS X" {
            Timer.scheduledTimer(timeInterval: 1, target: self.tableView, selector: #selector(tableView.reloadData), userInfo: nil, repeats: true)
        }
    }
    
    @objc func loadData() {
        self.missions = DeadlineDataManager.missions
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func render() {
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        self.title = "My missions"
    }
    
    
    @IBAction func addMission(_ sender: Any) {
        editItem(indexPath: nil, done: nil)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    func editItem(indexPath: IndexPath?, done:((Bool)->())?) {
        
        if let indexPath = indexPath {
            let item = missions[indexPath.row]
            showAlertWith(mission: item.mission, date: item.date, item: item)
        } else {
            showAlertWith(mission: nil, date: Date(), item: nil)
        }
        
        done?(true)
    }
    
    func deleteItem(indexPath: IndexPath, done:((Bool)->())?) {
        
        DeadlineDataManager.deleteMission(item: missions[indexPath.row])
        
        done?(true)
    }
    
    
    /// update or add item
    /// - Parameters:
    ///   - mission: mission
    ///   - date: date
    ///   - item: if item not nil, update the item
    func showAlertWith(mission: String?, date: Date?, item: DeadlineItem?) {
        
        let alert = UIAlertController(title: "edit", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "mission"
            textField.text = mission
        }
        
        alert.addAction(UIAlertAction(title: date==nil ? "" : DeadlineDataManager.dateFormatter.string(from: date!), style: .default, handler: { (action) in
            
            self.showDatePicker(currentDate: date) { (date) in
                self.showAlertWith(mission: alert.textFields?.first?.text, date: date, item: item)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if let mission = alert.textFields?.first?.text,
               let date = date,
               !mission.isEmpty {
                
                if let item = item {
                    item.mission = mission
                    item.date = date
                    DeadlineDataManager.updateMission(item: item)
                } else {
                    DeadlineDataManager.addMission(mission: mission, date: date)
                }
                
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
        missions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textcellId", for: indexPath) as! ItemTableViewCell
        
        cell.configure(item: missions[indexPath.row], indexPath: indexPath, delegate: self)
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

extension MissionController: DeadlineDataManagerDelegate {
    func deadlineDataManagerDidUpdateData() {
        loadData()
    }
}
