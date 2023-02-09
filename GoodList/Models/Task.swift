//
//  Task.swift
//  GoodList
//
//  Created by Назар Жиленко on 08.02.2023.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
