//
//  DateFormatter.swift
//  Push it
//
//  Created by Bart on 02/06/2021.
//

import Foundation

extension DateFormatter {

    static func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
