//
//  Int + Extensions.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 13.11.2022.
//

import Foundation

extension Int {
    
    func getMinutesAndSeconds() -> String {
        
        if self / 60 == 0 {
            return "\(self % 60) sec"
        }
        
        if self % 60 == 0 {
            return "\(self / 60) min"
        }
        
        return "\(self / 60) min \(self % 60) sec"
    }
    
    func convertSecond() -> (Int, Int) {
        let min = self / 60
        let sec = self % 60
        return (min, sec)
    }
    
    func setZeroForSecond() -> String {
        Double(self) / 10.0 < 1 ? ("0\(self)") : "\(self)"
    }
    
}
