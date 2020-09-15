//
//  ProjectView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import CoreData


class ProjectView: UIViewController {
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = Color.groupedBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 56
        tableView.sectionHeaderHeight = 38
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseId)
        
        return tableView
    }()
    lazy private var headerView: ProjectHeaderView = {
        let headerView = ProjectHeaderView(frame: .zero,
                                           headerType: self.type,
                                           project: self.viewModel.project,
                                           selectedIndex: self.viewModel.selectedIndex,
                                           segments: self.viewModel.segments)
        headerView.backgroundColor = Color.systemBackground
        return headerView
    }()
    lazy private var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
    }()
    lazy private var navigator: ProjectsNavigator? = {
        return self.navigationController as? ProjectsNavigator
    }()
    
    
    let type: HeaderState
    let viewModel: ProjectViewModel
    
    
    init(type: HeaderState, viewModel: ProjectViewModel) {
        self.type = type
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.fetchController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        addViews()
        setConstraints()
        bindViewModel()
        viewModel.fetchData() { [weak self] in
            self?.tableView.reloadData()
        }
    }
    

    func addViews() {
        self.navigationItem.rightBarButtonItem = addButton
        self.view.addSubview(headerView)
        self.view.addSubview(tableView)
    }
    
    
    func setConstraints() {
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        tableView.anchor(top: headerView.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: view.trailingAnchor)
    }
    
    
    
    func bindViewModel() {
        viewModel.selectedIndex.bind { [weak self] (index) in
            self?.viewModel.fetchData {
                self?.tableView.reloadData()
            }
        }
    }
    
    
    @objc func addTask() {
        let alert = UIAlertController(title: "Add new",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Task",
                                      style: .default) { (_) in
            self.navigator?.navigate(to: .newTask(task: nil,
                                                  type: .task,
                                                  project: self.viewModel.project))
        })
        
        switch type {
        case .project:
            alert.addAction(UIAlertAction(title: "Event",
                                          style: .default) { (_) in
                self.navigator?.navigate(to: .newTask(task: nil,
                                                      type: .event,
                                                      project: self.viewModel.project))
            })
        case .goal:
            alert.addAction(UIAlertAction(title: "Habit",
                                          style: .default) { (_) in
                self.navigator?.navigate(to: .newTask(task: nil,
                                                      type: .habit,
                                                      project: self.viewModel.project))
            })
        }
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        
        present(alert, animated: true)
    }
}


extension ProjectView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchController.sections?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseId, for: indexPath) as! TaskTableViewCell
        
        cell.configure(with: viewModel.fetchController.object(at: indexPath), with: self)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        if let isoDate = viewModel.fetchController.sections?[section].name {
            return Date(isoDate).string(state: .monthDay)
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let task = self.viewModel.fetchController.object(at: indexPath)
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { [weak self] (_, indexPath) in
            guard let self = self else { return }
            self.navigator?.navigate(to: .newTask(task: task,
                                                  type: task.typeAsEnum,
                                                  project: self.viewModel.project))
        }
        editAction.backgroundColor = Color.orange
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
            self?.deleteAction(task:task)
        }
        
        if task.typeAsEnum == .habit {
            return [deleteAction]
        }
        return [deleteAction, editAction]
    }
    
    
    
    func deleteAction(task: Task) {
        if task.typeAsEnum == .habit {
            let alert = UIAlertController(title: "Delete",
                                          message: nil,
                                          preferredStyle: .actionSheet)
            
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
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            
            present(alert, animated: true)
        } else {
            viewModel.delete(task)
        }
    }
    
}

extension ProjectView: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



//MARK:- Observe any changes
extension ProjectView: NSFetchedResultsControllerDelegate {
    
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


extension ProjectView: Progressable {
    
    
    func increment(task: Task) {
        self.viewModel.increment(task)
    }
    
    func decrement(task: Task) {
        self.viewModel.decrement(task)
    }
    
}
