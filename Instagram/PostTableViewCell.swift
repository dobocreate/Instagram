//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 岸田展明 on 2021/10/03.
//

import UIKit
import FirebaseStorageUI

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentLabel: UILabel!
    
    var commentText: [String?] = []
    
    @IBOutlet weak var commentButton2: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        // 画像の表示
        // Cloud Storageから画像をダウンロードしている間、ダウンロード中であることを示すインジケーターを表示する指定
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray          // グレーのクルクルアイコン
        
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        
        // Cloud Storageの画像保存場所を指定するだけで自動的に指定場所から画像をダウンロードしてUIImageViewに表示される
        postImageView.sd_setImage(with: imageRef)

        // キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"

        // 日時の表示
        self.dateLabel.text = ""
        
        if let date = postData.date {
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString = formatter.string(from: date)
            
            self.dateLabel.text = dateString
        }

        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        // いいねコメントの設定
        print("いいねカウント\(postData.likecomment2.count)")
        
        if postData.likecomment2.count != 0 {
            
            let likecount = postData.likecomment2.count - 1
            var c_text:String = ""
            
            if likecount > 1 {
                
                let count: Int = likecount - 1
                
                for i in 0..<count {
                    
                    c_text = c_text + "\(postData.likecomment2[i]!)\n"
                    
                    print(i)
                }
            }
            
            c_text = c_text + "\(postData.likecomment2[likecount]!)"

            commentLabel.text = c_text
        }
        else {
            
            commentLabel.text = ""
        }
        
        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
