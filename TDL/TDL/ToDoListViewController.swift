//
//  ViewController.swift
//  TDL
//
//  Created by Iori Suzuki on 2019/12/19.
//  Copyright © 2019 Iori Suzuki. All rights reserved.
//

import UIKit
import RealmSwift

final class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var editButton: UIBarButtonItem!
    private let cellIdentifile = "ToDoCell"
    private var toDoList: Results<ToDo>!
    
    private var notificationToken: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchAll()
        
        notificationToken = toDoList.observe{ [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            self.fetchAll()
            switch changes {
            case .initial, .update:
                self.tableView.reloadData()
            case .error(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private func fetchAll() {
        do {
            let realm = try Realm()
            toDoList = realm.objects(ToDo.self)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifile, for: indexPath)
        cell.textLabel?.text = toDoList[indexPath.row].title
        return cell
    }
    
    @IBAction private func editButtonTapped(_ sender: Any) {
        guard let editViewController = UIStoryboard(name: "EditViewController", bundle: nil).instantiateInitialViewController() as? EditViewController else {
            return
        }
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editViewController = UIStoryboard(name: "EditViewController", bundle: nil).instantiateInitialViewController() as? EditViewController else {
            return
        }
        editViewController.toDo = toDoList[indexPath.row]
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        fetchAll()
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { [weak self] action, view, handler in
            guard let self = self else { return }
            self.delete(by: self.toDoList[indexPath.row])
        }
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        return actions
    }
    
    private func delete(by toDo: ToDo) {
        do {
            let realm = try Realm()
            do {
                try realm.write {
                    realm.delete(toDo.self)
                }
            } catch let error {
                fatalError(error.localizedDescription)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}

