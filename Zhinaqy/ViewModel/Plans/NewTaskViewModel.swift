//
//  NewTaskViewModel.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation

class NewTaskViewModel {
    
    let coreDataManager: CoreDataManager
    let task: Task?
    let name: Bindable<String>
    let deadline: Bindable<Date>
    let notification: Bindable<Int>
    let repeats: Bindable<Int>
    let days: Bindable<[String]>
    let alerts: Bindable<[Date]>
    let start: Bindable<Date>
    let end: Bindable<Date>
    let comment: Bindable<String>
    let unit: Bindable<String>
    let count: Bindable<Int>
    lazy var notificationValues: [String] = {
        var temp = [String]()
        temp.append("None")
        for i in 1...20 {
            temp.append("\(i*5) minutes before")
        }
        return temp
    }()
    lazy var repetitionValues: [String] = {
        return eventRepetitionValues.filter({ $0 != "Never" })
    }()
    
    lazy var eventRepetitionValues: [String] = {
        var temp = [String]()
        temp.append("Never")
        temp.append("Every week")
        for i in 2...4 {
            temp.append("Every \(i) weeks")
        }
        return temp
    }()
    
    
    init(coreDataManager: CoreDataManager, task: Task?) {
        
        self.coreDataManager = coreDataManager
        self.task = task
        
        self.name = Bindable(task?.name ?? "")
        self.deadline = Bindable(task?.deadline ?? Date())
        self.notification = Bindable(Int(task?.notification ?? 0))
        if task?.type == "habit" {
            self.repeats = Bindable(Int(task?.repeats ?? 1) - 1)
        } else {
            self.repeats = Bindable(Int(task?.repeats ?? 0))
        }
        
        self.days = Bindable(task?.days ?? [])
        self.alerts = Bindable(task?.alerts ?? [])
        self.start = Bindable(task?.start ?? Date())
        self.end = Bindable(task?.end ?? Date())
        self.comment = Bindable(task?.comment ?? "")
        self.unit = Bindable(task?.unit ?? "time(s)")
        self.count = Bindable(Int(task?.count ?? 1) - 1 )
    }
    
    
    func done(type: NewTaskState, completion: @escaping(Result<String>) -> Void) {
        
        var content: [String: Any] {
            switch type {
            case .task:
                return  [
                    "name": name.value,
                    "notification": notification.value,
                    "start": deadline.value,
                    "type": "task"
                ]
            case .habit:
                return  [
                    "name": name.value,
                    "alerts": alerts.value,
                    "start": start.value,
                    "end": end.value,
                    "repeats": repeats.value + 1,
                    "days": days.value,
                    "count": count.value + 1,
                    "unit": unit.value,
                    "type": "habit"
                ]
            case .event:
                return  [
                    "name": name.value,
                    "notification": notification.value,
                    "start": deadline.value,
                    "end": end.value,
                    "repeats": repeats.value,
                    "days": days.value,
                    "comment": comment.value,
                    "type": "event"
                ]
            }
        }
        
        if let task = task {
            coreDataManager.update(entity: task, content: content, completion: completion)
        } else {
            coreDataManager.create(name: "Task", content: content, completion: completion)
        }
        
    }
}
