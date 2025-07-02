//
//  DateFormatterHelper.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import Foundation

enum DateFormatterHelper {
    static func format(date string: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: string) else { return string }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM, HH:mm"
        return formatter.string(from: date)
    }
}
