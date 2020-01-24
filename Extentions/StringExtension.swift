
import UIKit

extension String {
    
    static let Dot = "•"
    
    func substring(from: Int, to: Int) -> String {
        let from_index = self.index(self.startIndex, offsetBy: from)
        let to_index = self.index(self.startIndex, offsetBy: to)
        return String(self[from_index..<to_index])
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return String(self[...self.index(self.startIndex, offsetBy: from)])
    }
    
    var length: Int {
        return self.count
    }
    
    var hex: Int? {
        return Int(self, radix: 16)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func toBool() -> Bool? {
        switch self {
        case "Success", "success", "SUCCESS", "True", "true", "TRUE", "yes", "Yes", "YES", "1", "SUCCEED", "Succeed", "succeed":
            return true
        case "Failure", "Failure", "FAILURE", "False", "false", "FALSE", "no", "No", "NO", "0", "FAIL", "Fail", "fail", "", " ":
            return false
        default:
            return nil
        }
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[a-z]{2,3}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidMobileNumber() -> Bool {
        let PHONE_REGEX = "[0-9]{7,13}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isValidInput() -> Bool {
        let RegEx = "[A-Za-z0-9._# $%+-@]{4,15}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let RegEx = "[\\b([A-Za-z]{0,})([0-9._# $%+-@]{0,})]{5,}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    func isOTPValid() -> Bool {
        let RegEx = "[0-9]{6}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    func isBase64Valid() -> Bool {
        let RegEx = "^data:image/.*?;base64,(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    func DateFromTimeStamp() -> String {
        let epocTime = TimeInterval(Int(self)!) / 1000
        
        let mydate = Date.init(timeIntervalSince1970: epocTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        let dateObj = dateFormatter.string(from: mydate)
        
        return dateObj
    }
    
    func DateFromString() -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = DateFormatString(self)!
        return formatter.date(from: self)!
    }
    
    static let TicketDateFormat = "dd MMM yy \n HH:mm"
    
    func dateStrfromDateStr(format: String) -> String {
        let mydate = self.DateFromString()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: mydate)
    }
    
    func DateCurrentFromTimeStamp() -> Date {
        let epocTime = TimeInterval(Int(self)!)
        let mydate = Date.init(timeIntervalSince1970: epocTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        return dateFormatter.string(from: mydate).DateFromString()
    }
    
    func Date_TimeStamp() -> String {
        let epocTime = TimeInterval(Int(self)!)
        let mydate = Date.init(timeIntervalSince1970: epocTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        return dateFormatter.string(from: mydate)
    }
    
    func ToDouble() -> Double {
        return Double(self) ?? 0
    }
    
    func ToUptoTwoPints() -> String {
        return String.init(format: "%.2f", self.ToDouble())
    }
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func toNanoSeconds() -> String {
        if let seconds = Double(self) {
            return String.init(format: "%.0f", seconds * 1000000000)
        }
        return "0"
    }
    func toMilliSeconds() -> String {
        if let seconds = Double(self) {
            return String.init(format: "%.0f", seconds * 1000)
        }
        return "0"
    }
    
    func StringToObject() -> Dictionary<String,Any> {
        
        let jsonData = self.data(using: .utf8)
        
        if let jsonObj = try? JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.allowFragments) {
            return jsonObj as! Dictionary<String,Any>
        }
        return Dictionary<String,Any>()
    }
    
    
    
    
    func CounterFilter() -> String {
        let countNum = Double(self)!
        
        if countNum < 1000 {
            return self
        }
        else if countNum < (1000*1000) {
            return String.init(format: "%.2fK", countNum/1000)
        }
        else if countNum < (1000*1000*1000) {
            return String.init(format: "%.2fM", countNum/(1000*1000))
        }
        else if countNum < (1000*1000*1000*1000) {
            return String.init(format: "%.2fB", countNum/(1000*1000*1000))
        }
        else {
            return String.init(format: "%.2fT", countNum/(1000*1000*1000*1000))
        }
    }
}

extension Int64 {
    func CounterFilter() -> String {
        let countNum = Double(self)
        
        if countNum < 1000 {
            return "\(self)"
        }
        else if countNum < (1000*1000) {
            return String.init(format: "%.2fK", countNum/1000)
        }
        else if countNum < (1000*1000*1000) {
            return String.init(format: "%.2fM", countNum/(1000*1000))
        }
        else if countNum < (1000*1000*1000*1000) {
            return String.init(format: "%.2fB", countNum/(1000*1000*1000))
        }
        else {
            return String.init(format: "%.2fT", countNum/(1000*1000*1000*1000))
        }
    }
}

extension Int {
    func CounterFilter() -> String {
        let countNum = Double(self)
        
        if countNum < 1000 {
            return "\(self)"
        }
        else if countNum < (1000*1000) {
            return String.init(format: "%.2fK", countNum/1000)
        }
        else if countNum < (1000*1000*1000) {
            return String.init(format: "%.2fM", countNum/(1000*1000))
        }
        else if countNum < (1000*1000*1000*1000) {
            return String.init(format: "%.2fB", countNum/(1000*1000*1000))
        }
        else {
            return String.init(format: "%.2fT", countNum/(1000*1000*1000*1000))
        }
    }
}

extension Double {
    
    func ToUpto8() -> String {
        return String.init(format: "%.8f", self)
    }
    func ToUpto4() -> String {
        return String.init(format: "%.4f", self)
    }
    func ToZero() -> String {
        return String.init(format: "%.0f", self)
    }
    func Toone() -> String {
        return String.init(format: "%.1f", self)
    }
    func Date_TimeStamp() -> String {
        let mydate = Date.init(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        return dateFormatter.string(from: mydate)
    }
    
    func getFormatedDate() -> String {
        
        let date = Date.init(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.full
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeZone = TimeZone.current
        let localDateStr = dateFormatter.string(from: date)
        let localDate = dateFormatter.date(from: localDateStr) ?? Date().addingTimeInterval(-2)
        
        let calendar = Calendar.init(identifier: .gregorian)
        let components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: localDate, to: Date())
        
        if let years = components.year, years != 0 {
            
            return "\(years)y"
        }
        
        if let months = components.month, months != 0 {
            
            return "\(months)mo"
        }
        
        if let days = components.day, days != 0 {
            
            return "\(days)d"
        }
        
        if let hours = components.hour, hours != 0 {
            
            return "\(hours)h"
        }
        
        if let minutes = components.minute, minutes != 0 {
            
            return minutes > 1 ? "\(minutes)mins" : "\(minutes)min"
        }
        
        if let seconds = components.second, seconds != 0 {
            
            return "\(seconds)sec"
        }
        
        return "just now"
    }
}

let YES = true
let NO = false

func DateFormatString(_ dateTime: String) -> String? {
    
    let formatStrings: [[String:String]] = [[kDateFormatRegex: "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}\\.\\d{3}$", kDateFormatString: "yyyy-MM-dd HH:mm:ss.SSS"],
                                            [kDateFormatRegex: "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}$", kDateFormatString: "yyyy-MM-dd HH:mm:ss"],
                                            [kDateFormatRegex: "^\\d{2}-\\d{2}-\\d{4} \\d{2}:\\d{2}:\\d{2}.\\d{3}$", kDateFormatString: "dd-MM-yyyy HH:mm:ss.SSS"],
                                            [kDateFormatRegex: "^\\d{2}-\\d{2}-\\d{4} \\d{2}:\\d{2}:\\d{2}$", kDateFormatString: "dd-MM-yyyy HH:mm:ss"],
                                            [kDateFormatRegex: "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2} (AM|PM)$", kDateFormatString: "yyyy-MM-dd HH:mm a"],
                                            [kDateFormatRegex: "^\\d{2}-\\d{2}-\\d{4} \\d{2}:\\d{2} (AM|PM)$", kDateFormatString: "dd-MM-yyyy HH:mm a"],
                                            [kDateFormatRegex: "^\\d{2}-\\d{2}-\\d{4}$", kDateFormatString: "dd-MM-yyyy"],
                                            [kDateFormatRegex: "^\\d{4}-\\d{2}-\\d{2}$", kDateFormatString: "yyyy-MM-dd"],
                                            [kDateFormatRegex: "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}.\\d{1}$", kDateFormatString: "yyyy-MM-dd HH:mm:ss.S"],]
    
    for dictionary in formatStrings {
        if (dateTime as NSString).range(of: dictionary[kDateFormatRegex]!, options: .regularExpression).location != NSNotFound {
            return dictionary[kDateFormatString]!
        }
    }
    return nil
}

let kDateFormatRegex = "FormatCode"
let kDateFormatString = "MainFormat"
