//
//  FriendCell.swift
//  SinaWeibo
//
//

import UIKit

protocol FriendCellDelegate:class {
    func friendCellDidFollowClick(user:User,btn:UIButton)
}

class FriendCell: UITableViewCell {
    
    //关注按钮
    @IBOutlet weak var followBtn: UIButton!

    //头像
    @IBOutlet weak var iconView: BigIconView!
    //名称
    @IBOutlet weak var nameLabel: UILabel!
    //最新微博
    @IBOutlet weak var descriptionLabel: UILabel!
    //时间
    @IBOutlet weak var dateLabel: UILabel!
    
    private weak var delegate:FriendCellDelegate?
    
    var user:User?{
        didSet{
            updateUI()
        }
    }
    
    @IBAction func followClick(sender: UIButton) {
        delegate?.friendCellDidFollowClick(user!, btn: sender)
    }
    
    private func updateUI(){
        iconView.user = user
        nameLabel.text = user?.name
        descriptionLabel.text = user?.descriptionStr
        dateLabel.text = user?.created_at
        
        if user!.following!{
            followBtn.selected = false
        }else{
            followBtn.selected = true
        }
        
        print(followBtn.selected)
    }
    
    
    private struct Static{
        static let CellID = "friend"
    }
    
    class func cellWithTableView(tableView:UITableView,delegate:FriendCellDelegate?=nil) -> FriendCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(Static.CellID) as? FriendCell
        if cell == nil{
            cell = NSBundle.mainBundle().loadNibNamed("FriendCell", owner: nil, options: nil).first as? FriendCell
            cell?.delegate = delegate
        }
        return cell!
    }

}
