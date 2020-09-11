//
//  Color.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/11/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit.UIColor

struct Color {
    
    static let main = UIColor(red: 0.941, green: 0.769, blue: 0.106, alpha: 1.0)
    static let appearance = UserDefaults.standard.string(forKey: "appearance") ?? "system"
    
    static var red: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xFF3B30)
        } else {
            return UIColor(rgb: 0xFF453A)
        }
    }
    static var orange: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xFF9500)
        } else {
            return UIColor(rgb: 0xFF9F0A)
        }
    }
    static var yellow: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xFFCC00)
        } else {
            return UIColor(rgb: 0xFFD60A)
        }
    }
    static var green: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x34C759)
        } else {
            return UIColor(rgb: 0x32D74B)
        }
    }
    static var teal: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x5AC8FA)
        } else {
            return UIColor(rgb: 0x64D2FF)
        }
    }
    static var blue: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x007AFF)
        } else {
            return UIColor(rgb: 0x0A84FF)
        }
    }
    static var indigo: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x5856D6)
        } else {
            return UIColor(rgb: 0x5E5CE6)
        }
    }
    static var purple: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xAF52DE)
        } else {
            return UIColor(rgb: 0xBF5AF2)
        }
    }
    static var pink: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xFF2F55)
        } else {
            return UIColor(rgb: 0xFF375F)
        }
    }
    
}


extension  Color {
    
    static var systemBackground: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xFFFFFF)
        } else {
            return UIColor(rgb: 0x1C1C1E)
        }
    }
    static var secondarySystemBackground: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xEFEFF4)
        } else {
            return UIColor(rgb: 0x2C2C2E)
        }
    }
    static var tertiarySystemBackground: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xFFFFFF)
        } else {
            return UIColor(rgb: 0x3A3A3C)
        }
    }
    
}

extension  Color {
    
    static var groupedBackground: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xEFEFF4)
        } else {
            return UIColor(rgb: 0x000000)
        }
    }
    static var secondaryGroupedBackground: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xFFFFFF)
        } else {
            return UIColor(rgb: 0x1C1C1E)
        }
    }
    static var tertiaryGroupedBackground: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xEFEFF4)
        } else {
            return UIColor(rgb: 0x2C2C2E)
        }
    }
}

extension  Color {
    
    static var primaryFill: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x787880, a: 0.2)
        } else {
            return UIColor(rgb: 0x787880, a: 0.36)
        }
    }
    static var secondaryFill: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x787880, a: 0.16)
        } else {
            return UIColor(rgb: 0x787880, a: 0.32)
        }
    }
    static var tertiaryFill: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x767680, a: 0.12)
        } else {
            return UIColor(rgb: 0x767680, a: 0.24)
        }
    }
    static var quarternaryFill: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x74748, a: 0.08)
        } else {
            return UIColor(rgb: 0x747480, a: 0.18)
        }
    }
}

extension  Color {
    
    static var label: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x000000)
        } else {
            return UIColor(rgb: 0xFFFFFF)
        }
    }
    static var secondaryLabel: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x3C3C43, a: 0.6)
        } else {
            return UIColor(rgb: 0xEBEBF5, a: 0.6)
        }
    }
    static var tertiaryLabel: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x3C3C43, a: 0.3)
        } else {
            return UIColor(rgb: 0xEBEBF5, a: 0.3)
        }
    }
    static var quarternaryLabel: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x3C3C43, a: 0.18)
        } else {
            return UIColor(rgb: 0xEBEBF5, a: 0.18)
        }
    }
}

extension  Color {
    
    static var separator: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0x3C3C43, a: 0.29)
        } else {
            return UIColor(rgb: 0x545458, a: 0.65)
        }
    }
    static var opaqueSeparator: UIColor {
        if appearance == "light" || (appearance == "system" && !Date().darkMode) {
            return UIColor(rgb: 0xC6C6C8)
        } else {
            return UIColor(rgb: 0x38383A)
        }
    }
}

