//
//  PlansView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import CoreData

class PlansView: UIViewController {
    
    let viewModel: PlansViewModel
    
    lazy private var calendarView: CalendarView = {
        let calendarView = CalendarView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: self.view.bounds.width,
                                                      height: 0),
                                        fetchController: self.viewModel.fetchController,
                                        currentMonth: self.viewModel.currentMonth,
                                        currentDay: self.viewModel.currentDay,
                                        target: self,
                                        updateMonth: #selector(self.updateMonth))
        calendarView.backgroundColor = Color.groupedBackground
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        downSwipe.direction = .down
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        upSwipe.direction = .up
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        rightSwipe.direction = .right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        leftSwipe.direction = .left
        
        calendarView.addGestureRecognizer(downSwipe)
        calendarView.addGestureRecognizer(upSwipe)
        calendarView.addGestureRecognizer(rightSwipe)
        calendarView.addGestureRecognizer(leftSwipe)
        
        return calendarView
    }()
    
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = Color.systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 56
        tableView.sectionHeaderHeight = 38
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseId)
        
        return tableView
    }()
    
    
    lazy private var navigator: PlansNavigator? = {
        return self.navigationController as? PlansNavigator
    }()
    
    lazy private var heightConstraint: NSLayoutConstraint = {
        let constraint = self.calendarView.heightAnchor.constraint(equalToConstant: self.cellHeight + 68)
        constraint.isActive = true
        return constraint
    }()
    
    private var cellHeight: CGFloat {
        return self.view.bounds.width/7
    }

    private var isExpanded: Bool {
        return self.heightConstraint.constant > self.cellHeight + CalendarView.additionalHeight
    }
    
    
    init(viewModel: PlansViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.fetchController.delegate = self
        self.title = "Plans"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        viewModel.fetchData { [weak self] in
            self?.calendarView.reloadData()
            self?.tableView.reloadData()
        }
        addViews()
        setConstraints()
        self.bindViewModel()
    }
    
    
    func bindViewModel() {
        
        viewModel.currentMonth.bind { [weak self] (date) in
            self?.calendarView.titleLabel.text = date.string(state: .monthYear)
        }
        
        viewModel.currentDay.bind { [weak self] (date) in
            if let index = self?.viewModel.fetchController.sections?.firstIndex(where: { Date($0.name).same(.day, as: date)}) {
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: index),
                at: .top,
                animated: true)
            }
        }
    }
    

}


//MARK:- Actions
extension PlansView {
    
    
    @objc func swipeAction(sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .up:
            if isExpanded {
                self.swipeUpDown()
            }
        case .down:
            if !isExpanded {
                self.swipeUpDown()
            }
        case .left:
            changeMonth(toNext: true)
            break
        case .right:
            changeMonth(toNext: false)
            break
        default:
            break
        }
    }
    
    
    @objc func updateMonth(sender: UIButton) {
        changeMonth(toNext: sender.tag > 0)
    }
    
    
    func changeMonth(toNext: Bool) {
        calendarView.addTransition(toNext ? .fromRight : .fromLeft)
        viewModel.changeMonth(by: toNext ? 1 : -1) { [weak self] in
            self?.tableView.reloadData()
            self?.calendarView.reloadData()
        }
        self.swipeUpDown(changed: true)
    }
    
    
    func swipeUpDown(changed: Bool = false) {
        if changed {
            if isExpanded {
                heightConstraint.constant = self.cellHeight*CGFloat(self.viewModel.currentMonth.value.count(get: .weekOfMonth, from: .month)) + CalendarView.additionalHeight
            }
            calendarView.topConstraint.constant = CGFloat(viewModel.currentDay.value.element(.weekOfMonth) - 1)*cellHeight*(-1)
        } else if isExpanded {
            heightConstraint.constant = self.cellHeight + CalendarView.additionalHeight
            calendarView.topConstraint.constant = CGFloat(viewModel.currentDay.value.element(.weekOfMonth) - 1)*cellHeight*(-1)
        } else {
            heightConstraint.constant = self.cellHeight*CGFloat(self.viewModel.currentMonth.value.count(get: .weekOfMonth, from: .month)) + CalendarView.additionalHeight
            calendarView.topConstraint.constant = 0
        }
        self.keyboardAnimation {
            self.view.layoutIfNeeded()
        }
    }
    
    
}



//MARK:- UI updates
extension PlansView {
    
    func addViews() {
        self.view.addSubview(calendarView)
        self.view.addSubview(tableView)
    }
    
    func setConstraints() {
        calendarView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.safeAreaLayoutGuide.leadingAnchor,
                            trailing: view.safeAreaLayoutGuide.trailingAnchor)
        heightConstraint.constant = cellHeight + CalendarView.additionalHeight
        calendarView.topConstraint.constant = CGFloat(viewModel.currentDay.value.element(.weekOfMonth) - 1)*cellHeight*(-1)
        tableView.anchor(top: calendarView.bottomAnchor,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
}



//MARK:- UITableViewDatasource
extension PlansView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchController.sections?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseId, for: indexPath) as! TaskTableViewCell
        
        cell.configure(with: viewModel.fetchController.object(at: indexPath),
                       with: self)
  
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let isoDate = viewModel.fetchController.sections?[section].name {
            return SectionHeader(date: Date(isoDate))
        }
        
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let task = self.viewModel.fetchController.object(at: indexPath)
        
        let editAction = UITableViewRowAction(style: .default,
                                              title: "Edit") { [weak self] (_, indexPath) in
            guard let project = task.project else { return }
            self?.navigator?.navigate(to: .newTask(task: task,
                                                   type: task.typeAsEnum,
                                                   project: project))
        }
        editAction.backgroundColor = Color.orange
        
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: "Delete") { [weak self] (_, indexPath) in
            self?.deleteAction(task:task)
        }
        if task.typeAsEnum == .habit {
            return [deleteAction]
        }
        return [deleteAction, editAction]
    }
    
    
    
    func deleteAction(task: Task) {
        if task.typeAsEnum == .habit {
            let alert = UIAlertController(title: "Delete", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Only this habit instance",
                                          style: .default) { [weak self] (_) in
                self?.viewModel.delete(task)
                alert.dismiss(animated: true)
            })
            
            alert.addAction(UIAlertAction(title: "All instances",
                                          style: .default) { [weak self] (_) in
                self?.viewModel.deleteAll(task)
                alert.dismiss(animated: true)
            })
            
            alert.addAction(UIAlertAction(title: "Dismiss",
                                          style: .cancel,
                                          handler: nil))
            
            
            present(alert, animated: true)
        } else {
            viewModel.delete(task)
        }
    }
    
}



//MARK:- UITableViewDelegate
extension PlansView: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let project = self.viewModel.fetchController.object(at: indexPath).project {
            self.navigator?.navigate(to: .project(project: project))
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




//MARK:- NSFetchedResultsControllerDelegate
extension PlansView: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }

            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
        
        self.calendarView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections([sectionIndex], with: .automatic)
        case .delete:
            tableView.deleteSections([sectionIndex], with: .automatic)
        case .update:
            tableView.reloadSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}



//MARK:- Progressable
extension PlansView: Progressable {
    
    func increment(task: Task) {
        self.viewModel.increment(task)
    }
    
    func decrement(task: Task) {
        self.viewModel.decrement(task)
    }
    
}
