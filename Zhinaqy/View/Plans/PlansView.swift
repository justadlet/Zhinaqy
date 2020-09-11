//
//  PlansView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class PlansView: UIViewController {
    
    let viewModel: PlansViewModel
    
    lazy private var calendarView: CalendarView = {
        let calendarView = CalendarView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0), month: self.viewModel.currentMonth, day: self.viewModel.currentDay)
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
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseId)
        
        return tableView
    }()
    
    
    lazy private var rightNavButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
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
    
    
    
    
    
    init(viewModel:  PlansViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        addViews()
        setConstraints()
        bindViewModel()
    }
    
    
    
    private func bindViewModel() {
        
        viewModel.currentMonth.bind { [weak self] (date) in
            guard let self = self else { return }
            self.keyboardAnimation {
                self.viewModel.fetchData()
                self.calendarView.configure(days: self.viewModel.days)
                self.tableView.reloadData()
            }
        }
    }
    

}


//MARK:- Actions
extension PlansView {
    
    
    @objc func swipeAction(sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .up:
            self.swipeUpDown()
        case .down:
            self.swipeUpDown()
        case .left:
            calendarView.addTransition(.fromRight)
            viewModel.changeMonth(by: 1)
            self.swipeUpDown(changed: true)
            break
        case .right:
            calendarView.addTransition(.fromLeft)
            viewModel.changeMonth(by: -1)
            self.swipeUpDown(changed: true)
            break
        default:
            break
        }
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
    
    
    @objc func addTask() {
        let alert = UIAlertController(title: "Add new", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Task", style: .default, handler: { (_) in
            self.navigator?.navigate(to: .newTask(task: nil, type: .task))
        }))
        alert.addAction(UIAlertAction(title: "Event", style: .default, handler: { (_) in
            self.navigator?.navigate(to: .newTask(task: nil, type: .event))
        }))
        alert.addAction(UIAlertAction(title: "Habit", style: .default, handler: { (_) in
            self.navigator?.navigate(to: .newTask(task: nil, type: .habit))
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        
        present(alert, animated: true)
    }
    
    
}



//MARK:- UI updates
extension PlansView {
    
    func addViews() {
        self.navigationItem.rightBarButtonItem = rightNavButton
        self.view.addSubview(calendarView)
        self.view.addSubview(tableView)
    }
    
    func setConstraints() {
        calendarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        heightConstraint.constant = cellHeight + 68
        tableView.anchor(top: calendarView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
}



//MARK:- UITableViewDatasource
extension PlansView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.days.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.days[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseId, for: indexPath) as! TaskTableViewCell
        
        cell.configure(with: viewModel.days[indexPath.section].tasks[indexPath.row])
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var temp = viewModel.days[section].date.string(state: .monthDay)
        temp.append(" • " + viewModel.days[section].date.string(state: .weekDay))
        
        return temp
    }
    
    
}


extension PlansView:  UITableViewDelegate {
    
}
