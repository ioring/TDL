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
    private let data = ["aaa", "bbb", "ccc"]
    private let toDo = ToDo()
    private var toDoList: Results<ToDo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addToDataBase()
        fetchAll()
    }
    
    private func add(to realm: Realm) {
        do {
            try realm.write {
                toDo.title = "TODO"
                realm.add(toDo)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    private func addToDataBase() {
        do {
            let realm = try Realm()
            add(to: realm)
        } catch let error {
            fatalError(error.localizedDescription)
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
    
    @IBAction func editButtonTapped(_ sender: Any) {
        guard let editViewController = UIStoryboard(name: "EditViewController", bundle: nil).instantiateInitialViewController() as? EditViewController else {
            return
        }
        navigationController?.pushViewController(editViewController, animated: true)
    }
}

