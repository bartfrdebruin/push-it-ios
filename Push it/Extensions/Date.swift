//
//  Date.swift
//  Push it
//
//  Created by Bart on 02/06/2021.
//

import Foundation

extension Date {
    
    func today() -> String {
        
        let date = Date()
        return DateFormatter.formatter().string(from: date)
    }
    
    func twentyDaysAgo() -> String {

        guard let twentyDays = Calendar.current.date(
                byAdding: .day,
                value: -20,
                to: Date()) else {
            return ""
        }
        
        return DateFormatter.formatter().string(from: twentyDays)
    }
}
