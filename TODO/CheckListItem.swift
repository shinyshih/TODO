//
//  File.swift
//  TODO
//
//  Created by 施馨檸 on 2018/6/15.
//  Copyright © 2018 施馨檸. All rights reserved.
//

import Foundation

class CheckListItem: Codable {
    var itemName: String?
    var checked = false
    
    func toggle() {
        checked = !checked
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    static func saveToFile(items: [CheckListItem]) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(items) {
            let url = CheckListItem.documentsDirectory?.appendingPathComponent("item")
            try? data.write(to: url!)
            
            
        }
    }
    
    static func readItemsFromFile() -> [CheckListItem]? {
        let propertyDecoder = PropertyListDecoder()
        let url = CheckListItem.documentsDirectory?.appendingPathComponent("item")
        if let data = try? Data(contentsOf: url!), let items = try?propertyDecoder.decode([CheckListItem].self, from: data) {
            return items
        } else {
            return nil
        }
    }
    
}
