//
//  PlansViewModel.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import CoreData

class PlansViewModel {
    
    private let coreDataManager: CoreDataManager
    lazy var fetchController: NSFetchedResultsController<Task> = {
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.sortDescriptors = [ NSSortDescriptor(key: "start", ascending: false) ]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    let currentMonth: Bindable<Date> = Bindable(Date().start(of: .month))
    let currentDay: Bindable<Date> = Bindable(Date().start(of: .day))
    var days: [Day] = []
    
    init(with coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    
    func changeMonth(by value: Int) {
        currentDay.value = currentMonth.value.increment(by: value, .month).start(of: .month)
        currentMonth.value = currentMonth.value.increment(by: value, .month)
    }
    
    func fetchData() {
        do {
            try fetchController.performFetch()
            self.convert()
        } catch {
            print(error)
        }
    }
    
    
    func convert() {
        self.days = []
        for i in 0..<currentMonth.value.count(get: .day, from: .month) {
            let temp = currentMonth.value.increment(by: i, .day)
            if let tasks = fetchController.fetchedObjects?.filter({ $0.sameDay(as: temp) }) {
                days.append(Day(date: temp, tasks: tasks))
            }
        }
    }
}
