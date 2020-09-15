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
    let project: Project
    
    let name: Bindable<String>
    let date: Bindable<Date>
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
        var temp = [String]()
        temp.append("Every week")
        for i in 2...4 {
            temp.append("Every \(i) weeks")
        }
        return temp
    }()
    
    
    init(coreDataManager: CoreDataManager, task: Task?, project: Project) {
        
        self.coreDataManager = coreDataManager
        self.task = task
        self.project = project
        self.name = Bindable(task?.name ?? "")
        self.date = Bindable(task?.date ?? Date())
        self.notification = Bindable(Int(task?.notification ?? 0))
        self.repeats = Bindable(Int(task?.repeats ?? 1) - 1)
        self.days = Bindable(task?.days ?? [])
        self.alerts = Bindable(task?.alerts ?? [])
        
        if let start = task?.start, let date = task?.date {
            self.start = Bindable(Date(date: date, time: start))
        } else {
            self.start = Bindable(Date())
        }
        if let end = task?.end, let date = task?.date {
            self.end = Bindable(Date(date: date, time: end))
        } else {
            self.end = Bindable(Date())
        }
        self.comment = Bindable(task?.comment ?? "")
        self.unit = Bindable(task?.unit ?? "time(s)")
        self.count = Bindable(Int(task?.count ?? 1) - 1)
    }
    
    
    func done(type: NewTaskState,
              completion: @escaping(CoreDataResult) -> Void) {
        
        if name.value.count == 0 && name.value.count > 50 {
            completion(.wrongParameter(message: "Name must be between 1-50 characters"))
            return
        }
        switch type {
        case .task:
            if date.value <= Date().increment(.day).start(of: .day) {
                completion(.wrongParameter(message: "Date must be more than today"))
                return
            }
            if self.project.type == "goal" && date.value > project.deadline! {
                completion(.wrongParameter(message: "Date must be less than goal deadline"))
                return
            }
            if let task = task {
                coreDataManager.update(entity: task,
                                       content: self.taskContent(),
                                       completion: completion)
            } else {
                coreDataManager.create(name: "Task",
                                       content: self.taskContent(),
                                       completion: completion)
            }
        case .event:
            if start.value <= Date().increment(.day).start(of: .day) {
                completion(.wrongParameter(message: "Date must be more than today"))
                return
            }
            if let task = task {
                coreDataManager.update(entity: task,
                                       content: self.taskContent(),
                                       completion: completion)
            } else {
                coreDataManager.create(name: "Task",
                                       content: self.eventContent(),
                                       completion: completion)
            }
        case .habit:
            if days.value.count == 0 {
                completion(.wrongParameter(message: "Select at least one day"))
                return
            }
            if unit.value.count == 0 && unit.value.count > 20 {
                completion(.wrongParameter(message: "Unit must be between 1-20 characters"))
                return
            }
            coreDataManager.create(name: "Task",
                                   content: self.habitContent(),
                                   completion: completion)
        }

    }
}


extension NewTaskViewModel {
    
    
    ///Transforms parameters to "task" type
    func taskContent() -> [String: Any] {
        
        return [
            "id": UUID(),
            "type": "task",
            "name": self.name.value,
            "date": self.date.value.start(of: .day),
            "start": self.date.value.time,
            "notification": self.notification.value,
            "project": self.project
        ]
    }
    
    
    ///Transforms parameters to "event" type
    func eventContent() -> [String: Any] {
        return [
            "id": UUID(),
            "type": "event",
            "name": self.name.value,
            "date": self.start.value.start(of: .day),
            "start": self.start.value.time,
            "end": self.end.value.time,
            "notification": self.notification.value,
            "comment": self.comment.value,
            "project": self.project
        ]
    }
    
    
    ///Transforms parameters to "habit" type
    func habitContent() -> [[String: Any]] {
        
        let id = UUID()
        return self.dates().map { (date) -> [String: Any] in
            return [
                "id": id,
                "type": "habit",
                "name": self.name.value,
                "date": date,
                "start": date.increment(.day),
                "alerts": self.alerts.value,
                "count": Int32(self.count.value + 1),
                "days": self.days.value,
                "repeats": Int32(self.repeats.value + 1),
                "unit": self.unit.value,
                "project": self.project
            ]
        }
    }
    
    
    ///Returns dates that task will happen
    func dates() -> [Date] {
        var dates = [Date]()
        var start = self.start.value.start(of: .weekOfYear)
        
        while start < self.end.value.start(of: .day) {
            for day in self.days.value {
                if let index = Calendar.current.shortWeekdaySymbols.firstIndex(of: day.capitalized) {
                    let date = start.increment(by: index, .day)
                    if date >= self.start.value && date < self.end.value {
                        dates.append(date)
                    }
                }
            }
            start = start.increment(by: self.repeats.value + 1, .weekOfYear)
        }
        return dates
    }
}
