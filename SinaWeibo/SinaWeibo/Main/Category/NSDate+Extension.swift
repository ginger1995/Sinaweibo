//
//  NSDate+Extension.swift
//  新浪微博
//
//

import UIKit

extension NSDate {
    /**
    *  判断某个时间是否为今年
    */
    func isThisYear() -> Bool{
        let calendar = NSCalendar.currentCalendar()
        //获得某个时间的年月日时分秒
        let dateCmps = calendar.components(.Year, fromDate: self)
        let nowCmps = calendar.components(.Year, fromDate: NSDate())
        return dateCmps.year == nowCmps.year
    }
    
    /**
    *  判断某个时间是否为昨天
    */
    func isYesterday() -> Bool{
        var now = NSDate()
        // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
        // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        // 2014-04-30
        let dateStr = fmt.stringFromDate(self)
        let nowStr = fmt.stringFromDate(now)
        // 2014-10-30 00:00:00
        let date = fmt.dateFromString(dateStr)
        now = fmt.dateFromString(nowStr)!
        
        let calendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = [.Year,.Month,.Day]
        let cmps = calendar.components(unit, fromDate: date!, toDate: now, options: NSCalendarOptions.MatchStrictly)
        return cmps.year == 0 && cmps.month == 0 && cmps.day == 1
    }
    
    /**
    *  判断某个时间是否为今天
    */
    func isTody() -> Bool{
        let now = NSDate()
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let dateStr = fmt.stringFromDate(self)
        let nowStr = fmt.stringFromDate(now)
        return (dateStr as NSString).isEqualToString(nowStr)
    }
}
