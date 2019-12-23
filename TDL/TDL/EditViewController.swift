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
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    private let toDo = ToDo()
    
    override func viewDidLoad() {
        editButton.titleLabel?.text = "Add"
        navigationItem.title = "TODOを追加"
    }
    
    @IBAction func updateOrEditButtonTapped(_ sender: Any) {
        guard let text = textField.text else {
            preconditionFailure("textFieldがnilになることはない")
        }
        
        add(by: text)
    }
    
    private func add(by title: String) {
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
    
}
