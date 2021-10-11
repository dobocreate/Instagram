//
//  HomeViewController.swift
//  Instagram
//
//  Created by 岸田展明 on 2021/10/02.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    // 画面を更新する
    @IBAction func reloadButton(_ sender: Any) {
        
        tableView.reloadData()
    }
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // カスタムセルを登録する
        // PostTableViewCellを登録しているので、後で参照できる
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    // 画面が表示される前に呼び出され、他の画面から戻ってきた場合にも呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("DEBUG_PRINT: viewWillAppear")
        
        // ログイン済みか確認
        if Auth.auth().currentUser != nil {         // ログイン済みの場合
            
            // listenerを登録して投稿データの更新を監視する
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    
                    let postData = PostData(document: document)
                    
                    return postData
                }
                // TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    
    // 画面が消える前に実行される
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }

    // 表示するセルの個数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postArray.count
    }

    // 表示するセルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得してデータを設定する
        // ここが難しい
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        
        cell.setPostData(postArray[indexPath.row])
        
        let row = indexPath.row
        
        print("row : \(row)")
        
        // セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        // 投稿ボタンのアクションをソースコードで設定する
        cell.commentButton2.addTarget(self, action:#selector(handleButton2(_:forEvent:)), for: .touchUpInside)
        
        cell.commentTextField.addTarget(self, action: #selector(textFieldDidChange(textField:forEvent:row:)), for: .editingDidEndOnExit)

        return cell
    }
    
    // セルが選択された時のメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelectRowAt")
        
        var comment: String? = nil
        
        if let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
            
            comment = cell.commentTextField.text
        }
        
        print("comment: \(comment!)")
    }
    
    @objc func textFieldDidChange(textField:UITextField, forEvent event: UIEvent, row:Int) {
        
        print("textFieldDidChange reload : \(textField.text!)")
        
    }
    
    
    // 投稿ボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton2(_ sender:UIButton, forEvent event: UIEvent) {
        
        print("投稿ボタンがタップされました。")
        
        //self.tableView.reloadData()
        
        var likecomment2: [String?]

        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 特定の番号のセルのテキストフィールド情報を取得する
        var comment: String? = nil
        
        if let cell = tableView.cellForRow(at: indexPath!) as? PostTableViewCell {
            
            comment = cell.commentTextField.text
        }
        
        print("comment: \(comment!)")
        
        // 配列からタップされたインデックスのデータを取り出す
        // Firestoreからダウンロードしたデータ
        let postData = postArray[indexPath!.row]

        //self.tableView.reloadData()
        
        //postData = cell.setLikeCommnet(postData)

        // likesを更新する
        // 更新データを作成する
        
        print("likecomment2 \(postData.likecomment2.count)")
        
        if postData.likecomment2.count != 0 {
            
            likecomment2 = postData.likecomment2
            
            let comment2: String? = comment
            
            likecomment2.append(comment2)
            
            let count = postData.likecomment2.count - 1
            
            print("HomeVC likesComment2 \(count), \(likecomment2)")
            
            
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            
            // 配列を丸ごと更新する
            postRef.updateData(["likecomment2": likecomment2]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }}
            
            sender.setTitle("完了", for: .normal)
            
            
            
            //postRef.updateData(["likecomment2": updateValue])
        }
    }

    // セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        var likes: [String] = []

        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]

        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            
            // 更新データを作成する
            var updateValue: FieldValue
            
            if postData.likes.count != 0 {
                
                likes = postData.likes
                
                let count = postData.likes.count - 1
                
                print("HomeVC likesTXT \(likes[count])")
            }
            
            if postData.isLiked {
                
                // 「すでに」いいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            }
            else {

                // 「今回新たに」いいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            
            postRef.updateData(["likes": updateValue])
        }
    }
    
}
