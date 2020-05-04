//
//  StringExtension.swift
//  BootCampGroupie
//
//  Created by ZaeemZafar on 3/15/16.
//  Copyright © 2016 ZaeemZafar. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension String {
    
    func getNameInitials() -> String {
        
        let arrayString = self.components(separatedBy: " ")
        
        var resultString = ""
        
        if arrayString.count >= 2  {
            
            for nameString in arrayString {
                
                resultString = resultString + String(nameString.characters.prefix(1))
                
                if resultString.characters.count == 2 {
                    
                    break
                }
            }
        }
        else {
            
            resultString = String(self.characters.prefix(1))
        }
        
        return resultString.uppercased()
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidName: Bool {
        let validNameRegex = "[a-zA-Z][a-zA-Z ]*"
        let nameTest  = NSPredicate(format:"SELF MATCHES %@", validNameRegex)
        return nameTest.evaluate(with: self)
    }
    
    var dollarLocalizedPrice: String {
        return "$\(self )"
    }
    
    func base64ToImage() -> UIImage? {
       
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        
        return nil;
    }
    
    func formatPhoneNumber() -> String {
        let digits = CharacterSet.decimalDigits.inverted as CharacterSet
        let filtered1 = self.components(separatedBy: digits) as NSArray
        
        let filtered = filtered1.componentsJoined(by: "") as NSString
        
        if filtered.length == 11 {
            let formatted = NSString(format: "(%@) %@-%@", filtered.substring(with: NSMakeRange(1, 3)), filtered.substring(with: NSMakeRange(4, 3)), filtered.substring(with: NSMakeRange(7, 4))) as NSString
            
            return formatted as String
        } else if filtered.length == 10 {
            let formatted = NSString(format: "(%@) %@-%@", filtered.substring(with: NSMakeRange(0, 3)), filtered.substring(with: NSMakeRange(3, 3)), filtered.substring(with: NSMakeRange(6, 4))) as NSString
            
            return formatted as String
        }

        
        return ""
    }
    
    var validFormattedNumber: Bool {
        // Developer's Note:
        // This is only for formatted numbers and without CountryCode !!!
        return self.characters.count == 14
    }
    
    func trimWhiteSpaces() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func passwordContainNumber() -> Bool {
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: self)
        print(numberresult)
        
        return numberresult
    }
    
    func passwordContainLowercaseLetter() -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        print(capitalresult)
        
        let lowerLetterRegEx  = ".*[a-z]+.*"
        let lowertest = NSPredicate(format:"SELF MATCHES %@", lowerLetterRegEx)
        let lowerresult = lowertest.evaluate(with: self)
        print(lowerresult)
        
        return capitalresult && lowerresult
    }
    func passwordNotContainSpecialCharacter() -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {
            print("string contains special characters")
            return false
        }
        return true
    }
    
    func toDate(_ fomate:String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fomate
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.date(from: self)!
    }
    
    func toBool() -> Bool {
    
        return (Int(self) ?? 0) != 0
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.height
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .randomRGBValue(),
                       green: .randomRGBValue(),
                       blue:  .randomRGBValue(),
                       alpha: 1.0)
    }
    
    static func catchUpAvatarColor() -> UIColor {
        return UIColor(red:   233,
                       green: 233,
                       blue:  233,
                       alpha: 1.0)
    }

}

extension Double {
    
    func toString() -> String {
        return String(format: "%f",self)
    }
    
    func toString(WithDecimalPoint point: String) -> String {
        return String(format: "%"+point+"f",self)
    }
}

extension CGFloat {

    static func randomRGBValue() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension Float {
    
    var dollarLocalizedPrice: String {
        return String(format: "$%.1f", self)
    }
    
    var withTwoPointString: String {
        return String(format: "%.2f", self)
    }
    
    var withOnePointString: String {
        return String(format: "%.1f", self)
    }
    
}

extension Date {
    
    func toString(withFormat format: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func convertUTCTimeToLocalDate(dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-dd-MM"
        dateFormatter.timeZone =  NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from:dateString)
        
        dateFormatter.dateFormat = "MMMM dd yyyy" // 2017-07-14 //"MM/dd/yyyy hh:mm:ss a"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        return dateFormatter.string(from: self)
    }
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    func dateForEventDeta() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-dd-MM"
        return dateFormatter.string(from: self)
    }
    
}

extension UISearchBar {
    
    public func setNewcolor(_ color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
    }
}


extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}

extension Dictionary {

    func contains(Key key: String) -> Bool {
    
        var retVal: Bool = false
        
        let lazyMapCollection = self.keys
        
        let allKeys: [String] = Array(lazyMapCollection) as! [String]
        retVal = allKeys.contains(key)
        
        return retVal
    }
}



