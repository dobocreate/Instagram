//
//  TabBarController.swift
//  Instagram
//
//  Created by 岸田展明 on 2021/10/03.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }
    

    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ImageSelectViewController {
            // ImageSelectViewControllerは、タブ切り替えではなくモーダル画面遷移する
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            
            present(imageSelectViewController, animated: true)
            
            return false
        } else {
            // その他のViewControllerは通常のタブ切り替えを実施
            return true
        }
    }
    
    // ログインしているかを確認する
    // 外部引数を指定しない、内部引数はBool型（true or falseの2値をとる型）のanimated
    // animatedは必要なのか
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)       // スーパークラスのviewDidAppearを実行
        
        // currentUserがnilならログインしていない。Firebase AuthenticationのAuthクラスを利用
        if Auth.auth().currentUser == nil{
            
            // ログインしていないときの処理
            // selfはクラスのプロパティを設定する際に使用する
            // storyboard?オプショナル型になっているのか
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            
            // モーダル画面遷移
            self.present(loginViewController!, animated: true, completion: nil)
            
        }
    }
    
}
