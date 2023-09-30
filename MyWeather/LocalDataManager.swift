//
//  LocalDataManager.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/26/23.
//

import Foundation


class LocalDataManager {
    let userDefaults = UserDefaults.standard
    
    func checkUsingTime() -> Int {
        if let time = UserDefaults.standard.object(forKey: "time") as? Int {
            UserDefaults.standard.set(time + 1, forKey: "time")
            return time
        } else {
            UserDefaults.standard.set(1, forKey: "time")
            return 0
        }
        
    }
    
    func get() -> [Int] {
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
        print(savedIndices)
        if index >= savedIndices.count {
            print("too much!")
            return
        } else {
            print("\(cityList[savedIndices[index]].city_ascii) removed")
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
