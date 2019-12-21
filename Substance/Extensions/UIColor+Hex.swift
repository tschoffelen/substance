//
//  UIColor+Hex.swift
//
//  Created by Thomas Schoffelen on 21/09/2019.
//  Copyright © 2019 Schof.co. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String) {
        var rgb: UInt32 = 0
        Scanner(string: hex).scanHexInt32(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    var toHex: String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])

        return String(format: "%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
}

extension Date {

    var yearsFromNow: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }

    var monthsFromNow: Int {
        return Calendar.current.dateComponents([.month], from: self, to: Date()).month!
    }

    var weeksFromNow: Int {
        return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear!
    }

    var daysFromNow: Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day!
    }

    var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }

    var hoursFromNow: Int {
        return Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
    }

    var minutesFromNow: Int {
        return Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
    }

    var relativeTime: String {
        if yearsFromNow > 0 { return "\(yearsFromNow) year" + (yearsFromNow > 1 ? "s" : "") + " ago" }
        if monthsFromNow > 0 { return "\(monthsFromNow) month" + (monthsFromNow > 1 ? "s" : "") + " ago" }
        if weeksFromNow > 0 { return "\(weeksFromNow) week" + (weeksFromNow > 1 ? "s" : "") + " ago" }
        if isInYesterday { return "yesterday" }
        if daysFromNow > 0 { return "\(daysFromNow) day" + (daysFromNow > 1 ? "s" : "") + " ago" }
        if hoursFromNow > 0 { return "\(hoursFromNow) hour" + (hoursFromNow > 1 ? "s" : "") + " ago" }
        if minutesFromNow > 0 { return "\(minutesFromNow) minute" + (minutesFromNow > 1 ? "s" : "") + " ago" }
        return "just now"
    }

}

public extension UITextView {

    func editedWord() -> String {
        let cursorPosition = selectedRange.location
        var index = text.count
        var chars = ""

        for char in text.reversed() {
            index -= 1
            if char == " " {
                if index > cursorPosition {
                    chars = ""
                } else {
                    break
                }
            } else {
                chars = String(char) + chars
            }
        }

        return chars
    }

}

class DismissSegue: UIStoryboardSegue {

    override func perform() {
        self.source.presentingViewController?.dismiss(animated: true, completion: nil)
   }

}
