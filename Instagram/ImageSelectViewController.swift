//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 岸田展明 on 2021/10/02.
//

import UIKit

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // ライブラリボタンがプッシュされた場合に実行される
    @IBAction func handleLibraryButton(_ sender: Any) {
        
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // カメラボタンがプッシュされた場合に実行される
    @IBAction func handleCameraButton(_ sender: Any) {
        
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // キャンセルボタンがプッシュされた場合に実行される
    @IBAction func handleCancelButton(_ sender: Any) {
        
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // 写真を撮影/選択した場合に実行される
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[.originalImage] as! UIImage

            // あとでCLImageEditorライブラリで加工する
            print("DEBUG_PRINT: image = \(image)")

        }
    }

    // キャンセルされた場合に実行される
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // ImageSelectViewController画面を閉じてタブ画面に戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
