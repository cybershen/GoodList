//
//  TaskListViewController.swift
//  GoodList
//
//  Created by Назар Жиленко on 08.02.2023.
//

import UIKit
import RxSwift

class TaskListViewController: UIViewController {

    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController,
              let addTVC = navVC.viewControllers.first as? AddTaskViewController else { return }
        
        addTVC.taskSubjectObserver
            .subscribe(onNext: { task in
                print(task)
            })
            .disposed(by: disposeBag)
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
