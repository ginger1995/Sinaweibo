//
//  PersonView.swift
//  SinaWeibo
//

import UIKit

class PersonView: UIView {

   
    @IBOutlet weak var personBgImage: UIImageView!
    @IBOutlet weak var iconView: BigIconView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commonBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var followMeBtn: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.layer.cornerRadius = iconView.frame.size.width / 2 //设置半径为图片的宽
        iconView.clipsToBounds = true //裁剪
    }
    
    var user:User?{didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        iconView.user = user
        nameLabel.text = user?.name
        print(user?.friends_count)
        followBtn.setupBtnCount(user?.friends_count, title: "关注数:")
        followMeBtn.setupBtnCount(user?.followers_count, title: "粉丝数：")
        descriptionLabel.text = user?.descriptionStr
    }
   
    @IBAction func commonClick(sender: UIButton) {
    }
    
    @IBAction func followClick(sender: UIButton) {
    }
    
    @IBAction func followMeClick(sender: UIButton) {
    }
    
}
