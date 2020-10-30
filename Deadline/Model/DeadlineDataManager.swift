//
//  DeadlineDataManager.swift
//  Deadline
//
//  Created by April Yang on 2020/10/10.
//

import UIKit
import CoreData
import WidgetKit

class DeadlineDataManager {
    
    private let persistentContainer: NSPersistentCloudKitContainer
    private let viewContext: NSManagedObjectContext
    
    static let instance = DeadlineDataManager()
    static var dateFormatter: DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter
    }()
    
    private init() {
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        viewContext = persistentContainer.viewContext
    }
    
    static func sharedContainerURL() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.april.yang.Deadline")!
    }
    
    static func writeMissions(items: [DeadlineItem]) {
        let missions = items.map{MissionItem(mission: $0.mission ?? "", date: $0.date ?? Date())}
        let archiveURL = sharedContainerURL().appendingPathComponent("missions.json")
        let encoder = JSONEncoder()
        if let dataToSave = try? encoder.encode(missions) {
            do {
                try dataToSave.write(to: archiveURL)
            } catch {
                print("Error: Can't write conents \(error.localizedDescription)")
            }
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "DeadlineWidget")
    }
    
    static var missions: [DeadlineItem] {
        
        if var items = try? instance.persistentContainer.viewContext.fetch(DeadlineItem.fetchRequest()) as? [DeadlineItem]
        {
            items.sort { (left, right) -> Bool in
                if let leftDate = left.date,
                   let rightDate = right.date {
                    return leftDate.compare(rightDate).rawValue < 0
                }
                return false
            }
            DeadlineDataManager.writeMissions(items:items.prefix(upTo: 2).map{$0})
            
            return items
        }
        
        return []
    }

    static func addMission(mission: String, date: Date) {
        let object = DeadlineItem(context: instance.viewContext)
        object.mission = mission
        object.date = date
        instance.viewContext.insert(object)
        do {
            try  instance.viewContext.save()
        } catch {
            print("Save mission error \(error.localizedDescription)")
        }
        
    }
    
    static func updateMission(item: DeadlineItem) {
        
        instance.viewContext.refresh(item, mergeChanges: true)
        do {
            try  instance.viewContext.save()
        } catch {
            print("Refresh mission error \(error.localizedDescription)")
        }
        
    }
    
    static func deleteMission(item: DeadlineItem) {
        instance.viewContext.delete(item)
        do {
            try  instance.viewContext.save()
        } catch {
            print("Refresh mission error \(error.localizedDescription)")
        }
    }
}


