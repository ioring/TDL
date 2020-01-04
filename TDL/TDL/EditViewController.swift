//
//  EditViewController.swift
//  TDL
//
//  Created by Iori Suzuki on 2019/12/22.
//  Copyright © 2019 Iori Suzuki. All rights reserved.
//

import UIKit
import RealmSwift

final class EditViewController: UIViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var editLabel: UILabel!
    
    var toDo: ToDo?
    
    override func viewDidLoad() {
        
        if let toDo = toDo {
            editLabel.text = toDo.title
            navigationItem.title = "TODOを追加"
            editButton.setTitle("更新", for: .normal)
            
        } else {
            editLabel.text = ""
            navigationItem.title = "TODOを編集"
            editButton.setTitle("追加", for: .normal)
        }
    }
    
    @IBAction func updateOrEditButtonTapped(_ sender: Any) {
        guard let text = textField.text else {
            preconditionFailure("textFieldがnilになることはない")
        }
        
        if let toDo = toDo {
            edit(by: toDo)
        } else {
            let toDo = ToDo()
            add(by: text, to: toDo)
        }
    }
    
    private func add(by title: String, to toDo: ToDo) {
        do {
            let realm = try Realm()
            do {
                try realm.write {
                    toDo.title = title
                    realm.add(toDo)
                }
            } catch let error {
                fatalError(error.localizedDescription)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    private func edit(by toDo: ToDo) {
        do {
            let realm = try Realm()
            guard let title = textField.text else {
                preconditionFailure("textはnilにならない")
            }
            do {
                try realm.write {
                    toDo.title = title
                }
            } catch {
                fatalError(error.localizedDescription)
            }
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
