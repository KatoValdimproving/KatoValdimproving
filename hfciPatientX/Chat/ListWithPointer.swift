//
//  ListWithPointer.swift
//  NovaTrack
//
//  Created by developer on 03/03/21.
//  Copyright © 2021 Paul Zieske. All rights reserved.
//

import Foundation

struct ListWithPointer {
    var list = [String]()
    var pointer = 0
    
    init(with list: [String]) {
        self.list = list
    }
    
    func getPointerElement() -> String {
        return  self.list[pointer]
    }
    
    mutating func incrementPointer() {
        if self.pointer + 1 <= self.list.count - 1 {
            self.pointer += 1
        } else {
            self.pointer = 0
        }
    }
    
    mutating func decrementPointer() {
        if self.pointer - 1 >= 0 {
            self.pointer -= 1
        }
    }
   
    func printList() {
        for (index, element) in self.list.enumerated() {
            if index == self.pointer {
                print("\(index) -> \(element)")
            } else {
                print("\(index) ** \(element)")
            }
        }
    }
}
