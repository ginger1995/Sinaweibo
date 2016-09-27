//
//  StatusTool.swift
//  新浪微博
//
//  存放微博工具
//

import UIKit

class StatusTool: NSObject {

    private static let db:SQLiteDB = {
        let _db = SQLiteDB.sharedInstance("SinaWebo.sqlite")
        _db.execute("CREATE TABLE IF NOT EXISTS t_status (id integer PRIMARY KEY, status blob NOT NULL, idstr text NOT NULL);")
        return _db
    }()
    
    /**
    *  根据请求参数去沙盒中加载缓存的微博数据
    *
    *  param params 请求参数
    */
    class func statuesWithParams(params:[String:AnyObject], callBack:(statuses:[AnyObject]) -> Void) {
        
        var count = 20
        if let temp = params["count"] as? Int{
            count = temp
        }
        
        var sql = ""
        if let since_id = params["since_id"] {
            sql = "SELECT * FROM t_status WHERE idstr > \(since_id) ORDER BY idstr DESC LIMIT \(count);"
        }else if let max_id = params["max_id"] as? NSNumber{
            sql = "SELECT * FROM t_status WHERE idstr <= \(max_id.longLongValue) ORDER BY idstr DESC LIMIT \(count);"
        }else{
            sql = "SELECT * FROM t_status ORDER BY idstr DESC LIMIT \(count);"
        }
        
        var statuses = [AnyObject]()
        db.query(sql) { (rows) -> Void in
            for result in rows{
                let statusData = result["status"]?.asData()
                let status = NSKeyedUnarchiver.unarchiveObjectWithData(statusData!)
                statuses.append(status!)
            }
            callBack(statuses: statuses)
        }
    }
    /**
     *  存储微博数据到沙盒中
     *
     *  param statuses 需要存储的微博数据
     */
    class func saveStatues(statuses:[AnyObject]){
        
        // 要将一个对象存进数据库的blob字段,最好先转为NSData
        // 一个对象要遵守NSCoding协议,实现协议中相应的方法,才能转成NSData
        for status in statuses{
            let dict = status as! [String:AnyObject]
            let idstr = dict["idstr"]!
            let sql = "SELECT * FROM t_status WHERE idstr = \(idstr)"
            if db.query(sql).count == 0{
                let statusData = NSKeyedArchiver.archivedDataWithRootObject(status)
                db.execute("INSERT INTO t_status(status, idstr) VALUES (?, ?);", parameters: [statusData,idstr])
            }
            
        }
    }
}
