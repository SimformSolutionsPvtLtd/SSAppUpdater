//
//  String.swift
//  SSAppUpdater
//
//  Created by Rishita Panchal on 08/05/24.
//

import Foundation

extension String {
    ///  Formats a string representing a date and time into a `Date` object.
    func formatDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        return dateFormatter.date(from: self)
    }

    /// Extracts and returns integer components from a version string separated by periods.
    func extractVersionComponent() -> [Int] {
        return components(separatedBy: ".").compactMap { Int($0) }
    }
}
