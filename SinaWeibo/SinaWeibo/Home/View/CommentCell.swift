//
//  CommentCell.swift
//  SinaWeibo
//
//

import UIKit
import Kingfisher

class CommentCell: UITableViewCell {

    
    @IBOutlet weak var iconView: IconView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: StatusTextView!
  
    var comment:Comment?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        iconView.user = comment?.user
        userLabel.text = comment?.user?.name
        contentLabel.attributedText = comment?.text
        timeLabel.text = comment?.created_at

    }
    
    
    private struct Static {
        static let CellID = "comment"
    }
    
    class func cellWithTableView(tableView:UITableView) -> CommentCell{
        var cell =  tableView.dequeueReusableCellWithIdentifier(Static.CellID) as? CommentCell
        if cell == nil{
            cell = NSBundle.mainBundle().loadNibNamed("CommentCell", owner: nil, options: nil).first as? CommentCell
        }
        return cell!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //点击的时候不变色
        self.selectionStyle = .None
    }
}
