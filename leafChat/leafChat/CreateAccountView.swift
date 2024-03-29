//
//  CreateAccountView.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/02.
//

import UIKit
import KarteCore

class CreateAccountView: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImage)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        nameField.layer.borderColor = UIColor.gray.cgColor
        nameField.layer.borderWidth = 1.0
        nameField.layer.cornerRadius = 5.0
        nameField.placeholder = "leafme"
        
        emailField.layer.borderColor = UIColor.gray.cgColor
        emailField.layer.borderWidth = 1.0
        emailField.layer.cornerRadius = 5.0
        emailField.placeholder = "example@example.com"
        
        passwordField.layer.borderColor = UIColor.gray.cgColor
        passwordField.layer.borderWidth = 1.0
        passwordField.layer.cornerRadius = 5.0
        passwordField.placeholder = "your password"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Tracker.view("create_account", title: "アカウント作成")
//        print("KARTE_create_account")
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func onImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            imageView.image = image
            dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRegister(_ sender: Any) {
        let name = nameField.text!
        if name.count < 3 || name.count > 10 {
            showError(message: "You can resister your name length 3 to 11.")
        } else {
            AuthHelper().createAccount(email: emailField.text!, password: passwordField.text!, result: {
                success in
                if success {
                    DatabaseHelper().resisterUserInfo(name: self.nameField.text!, image: self.imageView.image!)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showError(message: "Check your Valid e-mail,or check password that length is longer than 6 characters.")
                }
            })
        }
    }
    
    func showError(message:String){
        let dialog = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(dialog, animated: true, completion: nil)
    }
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
