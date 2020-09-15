//
//  ProjectsView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import CoreData

class ProjectsView: UIViewController {
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    lazy private var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add,
                               target: self,
                               action: #selector(newProject))
    }()
    lazy private var navigator: ProjectsNavigator? = {
        return self.navigationController as? ProjectsNavigator
    }()
    
    
    private let viewModel: ProjectsViewModel

    
    init(viewModel: ProjectsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.fetchController.delegate = self
        self.title = "Projects"
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        viewModel.fetchData() {}
        addViews()
        setConstraints()
    }
    
    
    func addViews() {
        self.view.addSubview(tableView)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    
    func setConstraints() {
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    
    
    @objc func newProject() {
        let alert = UIAlertController(title: "Add new",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Project",
                                      style: .default) { (_) in
            self.navigator?.navigate(to: .newProject(project: nil,
                                                     type: .project))
        })
        
        alert.addAction(UIAlertAction(title: "Goal",
                                      style: .default) { (_) in
            self.navigator?.navigate(to: .newProject(project: nil,
                                                     type: .goal))
        })
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true)
    }
}

//MARK:- UITableView datasource
extension ProjectsView:  UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchController.sections?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let project = viewModel.fetchController.object(at: indexPath)
        
        if project.type == "goal" {
            return BasicTableViewCell(style: .subtitle,
                                      cellType: .subtitle(
                                        title: project.name ?? "",
                                        details: "Deadline: \(project.deadline?.string(state: .monthDayYear) ?? "")",
                                        accessory: .none))
        } else {
            return BasicTableViewCell(style: .default,
                                      cellType: .title(title: project.name ?? "",
                                                       accessory: .none))
        }
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return (viewModel.fetchController.sections?[section].name ?? "Project") + "s"
    }
    
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let project = self.viewModel.fetchController.object(at: indexPath)
        
        let editAction = UITableViewRowAction(style: .default,
                                              title: "Edit") { [weak self] (_, indexPath) in
            
            self?.navigator?.navigate(to: .newProject(project: project,
                                                      type: project.type == "goal" ? .goal : .project))
        }
        editAction.backgroundColor = Color.orange
        
        
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: "Delete") { [weak self] (_, indexPath) in
            self?.viewModel.delete(project)
        }
        
        return [deleteAction, editAction]
    }
}


//MARK:- UITableView delegate
extension ProjectsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        navigator?.navigate(to: .project(project: viewModel.fetchController.object(at: indexPath)))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ProjectsView: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
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
        self.tableView.endUpdates()
    }
}
