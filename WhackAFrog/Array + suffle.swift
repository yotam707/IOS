//
//  Array + suffle.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 4/24/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import Foundation
import Swift


extension MutableCollection where Indices.Iterator.Element == Index{
    
    mutating func shuffle(){
        let c = count
        guard c > 1 else { return }
        
        for(firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)){
            let d : IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0  else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}


extension Sequence{
    
    func shuffled() -> [Iterator.Element]{
        var result = Array(self)
        result.shuffle()
        return result
    }
}



