//
//  LoginViewController.swift
//  Instagram
//
//  Created by 岸田展明 on 2021/10/02.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    // ログインボタンがプッシュされた場合に実行される
    // any: 型のない型
    @IBAction func handleLoginButton(_ sender: Any) {
                
        if let address : String = mailAddressTextField.text, let password = passwordTextField.text {         // このif文は何のため？ nilなら実行しない

            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                return
            }
            
            // HUDで処理中を表示
            SVProgressHUD.show()

            //外部引数については記載しなくてもいいのか。「_ 」
            // 関数を定義しているわけではない
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in       // キーワード：クロージャー、ブロック
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                
                // HUDを消す
                SVProgressHUD.dismiss()

                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // アカウント作成ボタンがプッシュされた場合に実行される
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {

            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }
            
            // HUDで処理中を表示
            SVProgressHUD.show()

            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                
                // クロージャ内の処理（サーバ側からアカウント作成処理完了の通知が届いた時に実行される）
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")

                // 表示名を設定する
                let user = Auth.auth().currentUser
                
                if let user = user {
                    
                    let changeRequest = user.createProfileChangeRequest()
                    
                    changeRequest.displayName = displayName
                    
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        
                        // HUDを消す
                        SVProgressHUD.dismiss()

                        // 画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }   // クロージャ内の処理はここまで
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
