//
//  CoreDataStack.swift
//  Assessment2
//
//  Created by Leah Cluff on 6/21/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation
import CoreData


extension List {
    convenience init(item: String, isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.item = item
        self.isComplete = isComplete
    }
}
