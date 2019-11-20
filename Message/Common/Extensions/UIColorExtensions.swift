//
//  UIColorExtensions.swift
//  Message
//
//  Created by Minh Tâm on 11/7/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

#if !os(macOS)
import UIKit

// MARK: - Properties
public extension UIColor {
    
    /// SwifterSwift: Red component of UIColor (read-only).
    public var redComponent: Int {
        var red: CGFloat = 0.0
        getRed(&red, green: nil, blue: nil, alpha: nil)
        return Int(red * 255)
    }
    
    /// SwifterSwift: Green component of UIColor (read-only).
    public var greenComponent: Int {
        var green: CGFloat = 0.0
        getRed(nil, green: &green, blue: nil, alpha: nil)
        return Int(green * 255)
    }
    
    /// SwifterSwift: blue component of UIColor (read-only).
    public var blueComponent: Int {
        var blue: CGFloat = 0.0
        getRed(nil, green: nil, blue: &blue, alpha: nil)
        return Int(blue * 255)
    }
    
    /// SwifterSwift: Alpha of UIColor (read-only).
    public var alpha: CGFloat {
        var a: CGFloat = 0.0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    
    /// SwifterSwift: Hexadecimal value string (read-only).
    public var hexString: String {
        var red:    CGFloat = 0
        var green:    CGFloat = 0
        var blue:    CGFloat = 0
        var alpha:    CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return NSString(format: "#%06x", rgb).uppercased as String
    }
    
    /// SwifterSwift: Get color complementary (read-only, if applicable).
    public var complementary: UIColor? {
        return UIColor.init(complementaryFor: self)
    }
    
    /// SwifterSwift: Random color.
    public static var random: UIColor {
        let r = Int(arc4random_uniform(255))
        let g = Int(arc4random_uniform(255))
        let b = Int(arc4random_uniform(255))
        return UIColor(red: r, green: g, blue: b)
        
    }
    
    public var hexInt: Int? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let rgb =  (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            return nil
        }
    }
    
}

// MARK: - Methods
public extension UIColor {
    
    /// SwifterSwift: Blend two UIColors
    ///
    /// - Parameters:
    ///   - color1: first color to blend
    ///   - intensity1: intensity of first color (default is 0.5)
    ///   - color2: second color to blend
    ///   - intensity2: intensity of second color (default is 0.5)
    /// - Returns: UIColor created by blending first and seond colors.
    public static func blend(_ color1: UIColor, intensity1: CGFloat = 0.5, with color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        // http://stackoverflow.com/questions/27342715/blend-uicolors-in-swift
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
    
}

// MARK: - Initializers
public extension UIColor {
    
    /// SwifterSwift: Create UIColor from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int (example: 0xDECEB5).
    ///   - transparency: optional transparency value (default is 1).
    public convenience init(hex: Int, transparency: CGFloat = 1) {
        var trans: CGFloat {
            if transparency > 1 {
                return 1
            } else if transparency < 0 {
                return 0
            } else {
                return transparency
            }
        }
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff, transparency: trans)
    }
    
    /// SwifterSwift: Create UIColor from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1).
    public convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        var trans: CGFloat {
            if transparency > 1 {
                return 1
            } else if transparency < 0 {
                return 0
            } else {
                return transparency
            }
        }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    /// SwifterSwift: Create UIColor from a complementary of a UIColor (if applicable).
    ///
    /// - Parameter color: color of which opposite color is desired.
    public convenience init?(complementaryFor color: UIColor) {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace : ((_ color: UIColor) -> UIColor?) = { (color) -> UIColor? in
            if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components: [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1] ]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = UIColor(cgColor: colorRef!)
                return colorOut
            } else {
                return color
            }
        }
        
        let c = convertColorToRGBSpace(color)
        guard let componentColors = c?.cgColor.components else {
            return nil
        }
        
        let r: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[0]*255), 2.0))/255
        let g: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[1]*255), 2.0))/255
        let b: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[2]*255), 2.0))/255
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}


// MARK: - Material colors
public extension UIColor {
    
    /// SwifterSwift: Google Material design colors palette.
    public struct material {
        // https://material.google.com/style/color.html
        
        public static let red = red500
        public static let red50 = UIColor(hex: 0xFFEBEE)
        public static let red100 = UIColor(hex: 0xFFCDD2)
        public static let red200 = UIColor(hex: 0xEF9A9A)
        public static let red300 = UIColor(hex: 0xE57373)
        public static let red400 = UIColor(hex: 0xEF5350)
        public static let red500 = UIColor(hex: 0xF44336)
        public static let red600 = UIColor(hex: 0xE53935)
        public static let red700 = UIColor(hex: 0xD32F2F)
        public static let red800 = UIColor(hex: 0xC62828)
        public static let red900 = UIColor(hex: 0xB71C1C)
        public static let redA100 = UIColor(hex: 0xFF8A80)
        public static let redA200 = UIColor(hex: 0xFF5252)
        public static let redA400 = UIColor(hex: 0xFF1744)
        public static let redA700 = UIColor(hex: 0xD50000)
                
        public static let blue = blue500
        public static let blue50 = UIColor(hex: 0xE3F2FD)
        public static let blue100 = UIColor(hex: 0xBBDEFB)
        public static let blue200 = UIColor(hex: 0x90CAF9)
        public static let blue300 = UIColor(hex: 0x64B5F6)
        public static let blue400 = UIColor(hex: 0x42A5F5)
        public static let blue500 = UIColor(hex: 0x2196F3)
        public static let blue600 = UIColor(hex: 0x1E88E5)
        public static let blue700 = UIColor(hex: 0x1976D2)
        public static let blue800 = UIColor(hex: 0x1565C0)
        public static let blue900 = UIColor(hex: 0x0D47A1)
        public static let blueA100 = UIColor(hex: 0x82B1FF)
        public static let blueA200 = UIColor(hex: 0x448AFF)
        public static let blueA400 = UIColor(hex: 0x2979FF)
        public static let blueA700 = UIColor(hex: 0x2962FF)
                
        public static let green = green500
        public static let green50 = UIColor(hex: 0xE8F5E9)
        public static let green100 = UIColor(hex: 0xC8E6C9)
        public static let green200 = UIColor(hex: 0xA5D6A7)
        public static let green300 = UIColor(hex: 0x81C784)
        public static let green400 = UIColor(hex: 0x66BB6A)
        public static let green500 = UIColor(hex: 0x4CAF50)
        public static let green600 = UIColor(hex: 0x43A047)
        public static let green700 = UIColor(hex: 0x388E3C)
        public static let green800 = UIColor(hex: 0x2E7D32)
        public static let green900 = UIColor(hex: 0x1B5E20)
        public static let greenA100 = UIColor(hex: 0xB9F6CA)
        public static let greenA200 = UIColor(hex: 0x69F0AE)
        public static let greenA400 = UIColor(hex: 0x00E676)
        public static let greenA700 = UIColor(hex: 0x00C853)
    }
    
}


#endif
