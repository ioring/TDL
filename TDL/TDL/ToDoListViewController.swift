//
//  ViewController.swift
//  TDL
//
//  Created by Iori Suzuki on 2019/12/19.
//  Copyright © 2019 Iori Suzuki. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifile = "ToDoCell"
    let data = ["aaa", "bbb", "ccc"]
    let toDo = ToDo()
    let toDoList = Results<ToDo>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifile, for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func addToDataBase() {
        do {
            let realm = try Realm()
            add(to: realm)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func add(to realm: Realm) {
        do {
            try realm.write {
                toDo.title = data[0]
                realm.add(toDo)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}

