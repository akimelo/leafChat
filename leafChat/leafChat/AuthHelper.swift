//
//  AuthHelper.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/02.
//

import Foundation
import FirebaseAuth

class AuthHelper {
    
    func createAccount(email:String,password:String,result:@escaping(Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                result(true)
            } else {
                print("create-account:\(error!)")
                result(false)
            }
        }
    }
    
    func login(email:String,password:String,result:@escaping(Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: {
            authResult, error in
            if error == nil {
                result(true)
            } else {
                print("signin:\(error!)")
                result(false)
            }
        })
    }
    
    func email() -> String {
        guard let user = Auth.auth().currentUser else { return "" }
        return user.email!
    }
    
    func uid() -> String {
        guard let user = Auth.auth().currentUser else { return "" }
        return user.uid
    }
    
    func signout(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out")
        }
    }
    
}
