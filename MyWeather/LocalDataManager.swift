//
//  LocalDataManager.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/26/23.
//

import Foundation


class LocalDataManager {
    let userDefaults = UserDefaults.standard
    
    func get() -> [Int]? {
        let savedIndices = (userDefaults.array(forKey: "indices") ?? []) as [Int]
        return savedIndices
    }
    
    func add(index: Int) {
        var savedIndices = (userDefaults.array(forKey: "indices") ?? []) as [Int]
        savedIndices.append(index)
        userDefaults.set(savedIndices, forKey: "indices")
    }
    
    func remove(index : Int) {
        var savedIndices = (userDefaults.array(forKey: "indices") ?? []) as [Int]
        if index >= savedIndices.count {
            return
        } else {
            savedIndices.remove(at: index)
            userDefaults.set(savedIndices, forKey: "indices")
        }
    }
    
    func create(indices: [Int]) {
        for index in indices {
            self.add(index: index)
        }
    }
}
