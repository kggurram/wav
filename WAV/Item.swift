//
//  Item.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
