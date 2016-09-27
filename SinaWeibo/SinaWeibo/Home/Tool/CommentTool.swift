//
//  CommentTool.swift
//  SinaWeibo
//
//  存放评论工具
//

import UIKit

class CommentTool: NSObject {
    private static let db:SQLiteDB = {
        let _db = SQLiteDB.sharedInstance("SinaWebo.sqlite")
        _db.execute("CREATE TABLE IF NOT EXISTS t_comment (id integer PRIMARY KEY, comment blob NOT NULL, commentid text NOT NULL,page integer NOT NULL, statusid text NOT NULL);")
        return _db
    }()
    
    /**
     *  根据请求参数去沙盒中加载缓存的微博评论
     *
     *  param params 请求参数
     */
    class func commentWithParams(params:[String:AnyObject], callBack:(statuses:[AnyObject]) -> Void) {
        var sql = ""
        var count = 50
        if params["count"] != nil{
          count = params["count"] as! Int
        }
        
        let statusid = params["id"] as! NSNumber
        
        if let page = params["page"] as? Int{
            sql = "SELECT * FROM t_comment WHERE page = \(page) AND statusid = \(statusid.longLongValue) ORDER BY commentid DESC LIMIT \(count);"
        }else{
            sql = "SELECT * FROM t_comment WHERE statusid = \(statusid.longLongValue) ORDER BY commentid DESC LIMIT \(count);"
        }
        
        var comments = [AnyObject]()
        db.query(sql) { (rows) -> Void in
            for result in rows{
                let commentData = result["comment"]?.asData()
                let comment = NSKeyedUnarchiver.unarchiveObjectWithData(commentData!)
                comments.append(comment!)
            }
            callBack(statuses: comments)
        }
    }
    /**
     *  存储评论数据到沙盒中
     *
     *  param statuses 需要存储的微博数据
     */
    class func saveComments(comments:[AnyObject],page:Int,id:AnyObject){
        // 要将一个对象存进数据库的blob字段,最好先转为NSData
        // 一个对象要遵守NSCoding协议,实现协议中相应的方法,才能转成NSData
        for comment in comments{
            let dict = comment as! [String:AnyObject]
            
            let sql = "SELECT * FROM t_comment WHERE commentid = \((dict["id"] as! NSNumber).longLongValue)"
            if db.query(sql).count == 0{
                let statusData = NSKeyedArchiver.archivedDataWithRootObject(comment)
                db.execute("INSERT INTO t_comment(comment,commentid, page, statusid) VALUES (?,?,?,?);", parameters: [statusData,"\((dict["id"] as! NSNumber).longLongValue)",page,"\(id.longLongValue)"])
            }
        }
    }

}
