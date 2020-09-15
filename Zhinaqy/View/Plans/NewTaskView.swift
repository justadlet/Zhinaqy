//
//  NewTaskView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

enum NewTaskState: String {
    case task
    case event
    case habit
}


class NewTaskView: UITableViewController {
    
    
    //MARK: UI Variables
    lazy private var rightNavButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Done"
        button.style = .done
        button.action = #selector(save)
        button.target = self
        return button
    }()
    
    lazy private var startDatePicker: BindableDatePicker = {
        let datePicker = BindableDatePicker()
        datePicker.datePickerMode = self.type == .habit ? .date : .dateAndTime
        return datePicker
    }()
    
    lazy private var endDatePicker: BindableDatePicker = {
        let datePicker = BindableDatePicker()
        datePicker.datePickerMode = self.type == .habit ? .date : .time
        return datePicker
    }()
    
    lazy private var dateDatePicker: BindableDatePicker = {
        let datePicker = BindableDatePicker()
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    lazy private var alertDatePicker: BindableDatePicker = {
        let datePicker = BindableDatePicker()
        datePicker.datePickerMode = .time
        return datePicker
    }()
    
    lazy private var notificationPicker: BindablePickerView = {
        let picker = BindablePickerView()
        return picker
    }()
    
    lazy private var repeatsPicker: BindablePickerView = {
        let picker = BindablePickerView()
        return picker
    }()
    
    lazy private var countPicker: BindablePickerView = {
        let picker = BindablePickerView()
        return picker
    }()
 
    
    let type: NewTaskState
    let viewModel: NewTaskViewModel
    
    
    init(type: NewTaskState, viewModel: NewTaskViewModel) {
        self.type = type
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        self.tableView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        self.addViews()
        self.bindViewModel()
    }
    
    
    func addViews() {
        self.tableView = UITableView(frame: .zero,
                                     style: .grouped)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.navigationItem.rightBarButtonItem = rightNavButton
    }
    
    
    private func bindViewModel() {
        endDatePicker.bind(with: viewModel.end)
        startDatePicker.bind(with: viewModel.start)
        dateDatePicker.bind(with: viewModel.date)
        notificationPicker.bind(with: viewModel.notificationValues,
                                with: viewModel.notification)
        repeatsPicker.bind(with: viewModel.repetitionValues,
                           with: viewModel.repeats)
        viewModel.days.bind { [weak self] _ in
            self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 3)],
                                       with: .automatic)
        }
        viewModel.alerts.bind { [weak self] (_) in
            self?.tableView.reloadSections([4],
                                           with: .automatic)
        }
        countPicker.bind(with: Array(1...50).map({ "\($0)" }),
                         with: viewModel.count)
    }
    
    
    
    @objc private func save() {
        viewModel.done(type: type) { result in
            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .error(let type):
                print(type.rawValue)
                break
            case .wrongParameter(let message):
                print(message)
                break
            }
        }
    }
}



extension NewTaskView {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch type {
        case .task:
            return 2
        case .habit:
            return 5
        case .event:
            return 3
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if type == .habit && section == 4 {
            return viewModel.alerts.value.isEmpty ? 1 : 2
        }
        
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            return TextFieldTableViewCell(placeholder: "Type \(type.rawValue) name",
                                          bindable: viewModel.name)
        }
        
        switch type {
        case .task:
            if indexPath.row == 0 {
                return BasicTableViewCell(
                        style: .value1,
                        cellType: .rightDetail(
                            title: "Deadline",
                            details: viewModel.date.value.string(state: .dateTime),
                            accessory: .disclosureIndicator))
            } else {
                return BasicTableViewCell(
                        style: .value1,
                        cellType: .rightDetail(
                            title: "Notification",
                            details: viewModel.notificationValues[viewModel.notification.value],
                            accessory: .disclosureIndicator))
            }
        case .habit:
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    return BasicTableViewCell(
                            style: .value1,
                            cellType: .rightDetail(
                                title: "Daily goal",
                                details: "\(viewModel.count.value + 1)",
                                accessory: .disclosureIndicator))
                } else {
                    return TextFieldTableViewCell(placeholder: "Unit", bindable: viewModel.unit)
                }
            } else if indexPath.section == 2 {
                if indexPath.row == 0 {
                    return BasicTableViewCell(
                            style: .value1,
                            cellType: .rightDetail(
                                title: "Start",
                                details: viewModel.start.value.string(state: .monthDayYear),
                                accessory: .disclosureIndicator))
                } else {
                    return BasicTableViewCell(
                            style: .value1,
                            cellType: .rightDetail(
                                title: "End",
                                details: viewModel.end.value.string(state: .monthDayYear),
                                accessory: .disclosureIndicator))
                }
            } else if indexPath.section == 3 {
                if indexPath.row == 0 {
                    return BasicTableViewCell(
                            style: .value1,
                            cellType: .rightDetail(
                                title: "Repeats",
                                details: viewModel.repetitionValues[viewModel.repeats.value],
                                accessory: .disclosureIndicator))
                } else {
                    return DaysTableViewCell(bindable: viewModel.days)
                }
            } else {
                if indexPath.row == 0 {
                    return BasicTableViewCell(
                            style: .value1,
                            cellType: .rightDetail(
                                title: "Alerts",
                                details: "Add",
                                accessory: .disclosureIndicator))
                } else {
                    return AlertsTableViewCell(alerts: viewModel.alerts)
                }
            }
        case .event:
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    return BasicTableViewCell(
                            style: .value1,
                            cellType: .rightDetail(
                                title: "Start",
                                details: viewModel.start.value.string(state: .dateTime),
                                accessory: .disclosureIndicator))
                } else {
                    return BasicTableViewCell(
                            style: .value1,
                            cellType: .rightDetail(
                                title: "End",
                                details: viewModel.end.value.string(state: .time),
                                accessory: .disclosureIndicator))
                }
            } else {
                if indexPath.row == 0 {
                    return BasicTableViewCell(
                        style: .value1,
                        cellType: .rightDetail(
                            title: "Notification",
                            details: viewModel.notificationValues[viewModel.notification.value],
                            accessory: .disclosureIndicator))
                } else {
                    return TextViewTableViewCell(placeholder: "Your comment", bindable: viewModel.comment)
                }
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "\(type.rawValue.capitalized) name"
        }
        
        switch type {
        case .task:
            return "Additional info"
        case .habit:
            if section == 1 {
                return "Habit period"
            } else if section == 2 {
                return "Repetition"
            } else {
                return "Additional info"
            }
        case .event:
            if section == 1 {
                return "Event start and end"
            } else {
                return "Additional info"
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 || (type == .habit && indexPath == IndexPath(row: 1, section: 1)) {
            return 44
        }
        
        if type == .habit && indexPath == IndexPath(row: 1, section: 3)  {
            return (self.tableView.bounds.width - 80)/7 + 16
        }
        
        if type == .event && indexPath == IndexPath(row: 1, section: 2) {
            return 200
        }
        
        return UITableView.automaticDimension
    }
    
}





extension NewTaskView {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        switch type {
        case .task:
            if indexPath == IndexPath(row: 0, section: 1) {
                self.showDatePickerView(datePicker: dateDatePicker) { [weak self] (_) in
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            } else if indexPath == IndexPath(row: 1, section: 1) {
                self.showPickerView(pickerView: notificationPicker) { [weak self] (_) in
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        case .habit:
            if indexPath == IndexPath(row: 0, section: 1) {
                self.showPickerView(pickerView: countPicker) { [weak self] (_) in
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            } else if indexPath.section == 2 {
                self.showDatePickerView(datePicker: indexPath.row == 0 ? startDatePicker : endDatePicker) { [weak self] (_) in
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }  else if indexPath == IndexPath(row: 0, section: 3)  {
                self.showPickerView(pickerView: repeatsPicker) { [weak self] (_) in
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            } else if indexPath == IndexPath(row: 0, section: 4) {
                self.showDatePickerView(datePicker: alertDatePicker) { [weak self] (_) in
                    guard let self = self else { return }
                    if !self.viewModel.alerts.value.contains(self.alertDatePicker.date) {
                        self.viewModel.alerts.value.append(self.alertDatePicker.date)
                    }
                    self.tableView.reloadSections([4], with: .automatic)
                }
            }
        case .event:
            if indexPath.section == 1 {
                self.showDatePickerView(datePicker: indexPath.row == 0 ? startDatePicker : endDatePicker) { [weak self] (_) in
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            } else if indexPath == IndexPath(row: 0, section: 2) {
                self.showPickerView(pickerView: notificationPicker) { [weak self] (_) in
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
