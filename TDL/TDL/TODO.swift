//
//  TODO.swift
//  TDL
//
//  Created by Iori Suzuki on 2019/12/20.
//  Copyright © 2019 Iori Suzuki. All rights reserved.
//

import Foundation
import RealmSwift

class ToDo: Object {
    dynamic var title = ""
    dynamic var createdDate = Date()
}
