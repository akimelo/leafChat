//
//  AddFriendView.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/05.
//

import UIKit
import KarteCore

class AddFriendView: UIViewController {

    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var qrView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    
    let uid = AuthHelper().uid()
    let database = DatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idLabel.text = "MyID:\(uid)"
        qrView.image = makeQRCode(text: uid)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Tracker.view("search_friends", title: "友達検索")
//        print("KARTE_search_friends")
    }
    
    @IBAction func onSearch(_ sender: Any) {
        conform(id: idField.text!)
    }
    
    @IBAction func onCopy(_ sender: Any) {
        UIPasteboard.general.string = uid
    }
    
    func makeQRCode(text: String) -> UIImage? {
        guard let data = text.data(using: .utf8) else { return nil }
        let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data])!
        return UIImage(ciImage: qr.outputImage!)
    }
    
    func conform(id:String) {
        database.getUserName(userID: id, result: {
            result in
            if result == ""{
                self.showError(message: "Can't find friend's ID")
            } else {
                self.performSegue(withIdentifier: "conform", sender: UserData(id: id, name: result))
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "conform"{
            let data = sender as! UserData
            let vc = segue.destination as! ConformView
            vc.userID = data.id
            vc.name = data.name
        }
        if segue.identifier == "qr"{
            let vc = segue.destination as! QRScanner
            vc.qrScaned = {
                id in
                self.conform(id: id)
            }
        }
    }
    
    func showError(message:String){
        let dialog = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(dialog, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class ConformView :UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userID = ""
    var name = ""
    
    var database = DatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameLabel.text = name
        database.getImage(userID: userID, imageView: imageView)
        imageView.layer.cornerRadius = imageView.frame.height*0.5
        imageView.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Tracker.view("add_friends", title: "友達追加")
//        print("KARTE_add_friends")
    }
    
    @IBAction func onAdd(_ sender: Any) {
        database.createRoom(userID: userID)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

struct UserData{
    let id:String
    let name:String
}
