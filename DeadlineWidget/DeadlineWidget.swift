//
//  DeadlineWidget.swift
//  DeadlineWidget
//
//  Created by April Yang on 2020/10/29.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    typealias Entry = DeadlineEntry
    
    func placeholder(in context: Context) -> DeadlineEntry {
        DeadlineEntry(date: Date(), mission: [MissionItem(mission: "mission", date: Date()), MissionItem(mission: "mission", date: Date())])
    }

    func getSnapshot(in context: Context, completion: @escaping (DeadlineEntry) -> ()) {
        let entry = DeadlineEntry(date: Date(), mission: [MissionItem(mission: "mission", date: Date()), MissionItem(mission: "mission", date: Date())])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DeadlineEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        let currentDate = Date()
        let missions = readMissions()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            let entry = DeadlineEntry(date: entryDate, mission: missions.map{MissionItem(mission: $0.mission, date: $0.date.addingTimeInterval((TimeInterval)(-3600*hourOffset)))})
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DeadlineEntry: TimelineEntry {
    let date: Date
    let mission: [MissionItem]
}

func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.april.yang.Deadline")!
}

func readMissions() -> [MissionItem]{
    var missions: [MissionItem] = []
    let archiveURL = sharedContainerURL().appendingPathComponent("missions.json")
    let decoder = JSONDecoder()
    if let codeData = try? Data(contentsOf: archiveURL) {
        do {
            missions = try decoder.decode([MissionItem].self, from: codeData)
        } catch {
            print("Error: Can't decode conents \(error.localizedDescription)")
        }
    }
    return missions
}

struct DeadlineWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        VStack(alignment: .leading){
            MissionView(mission: entry.mission[0])
            if entry.mission.count > 1 {
                Text("")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, idealHeight: 1, maxHeight: 1, alignment: .center)
                    .background(Color.white)
                MissionView(mission: entry.mission[1])
            }
        }.frame(minWidth: 0, idealWidth: 200, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.black)
    }
}

struct MissionView: View {
    
    var mission: MissionItem
    var body: some View {
        VStack(alignment: .leading) {
            Text(mission.leftTimeStr()).bold()
                .foregroundColor(mission.exceed() ? .red : .white)
            Text(mission.mission).italic()
                .foregroundColor(.white)
        }
    }
}

@main
struct DeadlineWidget: Widget {
    let kind: String = "DeadlineWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DeadlineWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Deadline list")
        .description("List the last two upcoming deadline.")
        .supportedFamilies([.systemMedium])
    }
}

struct DeadlineWidget_Previews: PreviewProvider {
    static var previews: some View {
        DeadlineWidgetEntryView(entry: DeadlineEntry(date: Date(), mission: [MissionItem(mission: "mission", date: Date()), MissionItem(mission: "mission", date: Date())]))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
