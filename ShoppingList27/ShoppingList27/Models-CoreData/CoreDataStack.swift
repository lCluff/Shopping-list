//
//  CoreDataStack.swift
//  ShoppingList27
//
//  Created by Leah Cluff on 6/21/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation
import CoreData


extension Task {
    convenience init(name: String,  notes: String? = nil, due: Date? = nil, isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.isComplete = isComplete
    }
}
