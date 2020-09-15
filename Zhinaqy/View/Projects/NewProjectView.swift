//
//  NewProjectView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/12/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

public enum NewProjectState: String {
    case project
    case goal
}

class NewProjectView: UITableViewController {
    
    private let viewModel: NewProjectViewModel
    private let type: NewProjectState
    
    lazy private var deadlineDatePicker: BindableDatePicker = {
        let datePicker = BindableDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    lazy private var saveButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProject))
    }()
    
    
    init(viewModel: NewProjectViewModel, type: NewProjectState) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        addViews()
        bindViewModel()
    }
    
    
    func addViews() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func bindViewModel() {
        deadlineDatePicker.bind(with: viewModel.deadline)
    }
    
    
    
    @objc func saveProject() {
        viewModel.save(type: type) { (result) in
            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
    }
}


//MARK:- UItableView datasource
extension NewProjectView {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return type == .project ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            return TextFieldTableViewCell(
                        placeholder: "Type \(type.rawValue) name",
                        bindable: viewModel.name)
        } else {
            return BasicTableViewCell(
                        style: .value1,
                        cellType: .rightDetail(
                            title: "Deadline",
                            details: viewModel.deadline.value.string(state: .monthDayYear),
                            accessory: .disclosureIndicator))
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            self.showDatePickerView(datePicker: deadlineDatePicker) { (_) in
                self.tableView.reloadRows(at: [indexPath],
                                          with: .automatic)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
