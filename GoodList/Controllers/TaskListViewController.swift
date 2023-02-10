//
//  TaskListViewController.swift
//  GoodList
//
//  Created by Назар Жиленко on 08.02.2023.
//

import UIKit
import RxSwift
import RxRelay

class TaskListViewController: UIViewController {

    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    
    private var filteredTasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    @IBAction func priorityValueChanged(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: sender.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController,
              let addTVC = navVC.viewControllers.first as? AddTaskViewController else { return }
        
        addTVC.taskSubjectObserver
            .subscribe(onNext: { task in
                
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                
                self.tasks.accept(existingTasks)
                self.filterTasks(by: priority)
            })
            .disposed(by: disposeBag)
    }
    
    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            filteredTasks = tasks.value
        } else {
            tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
            }
            .subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                print(tasks)
            })
            .disposed(by: disposeBag)
        }
    }
}

// MARK: - UITableViewDelegate

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        
        return cell
    }
}
