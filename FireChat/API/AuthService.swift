//
//  AuthService.swift
//  FireChat
//
//  Created by Edward McGuiggan on 11/23/20.
//

import Foundation
import Firebase
import UIKit



struct RegistrationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}


struct AuthService {
    static let shared = AuthService()
    
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    func createUser(credentials: RegistrationCredentials, completion: ((Error?) -> Void)?) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images\(filename)")
        
        ref.putData(imageData, metadata: nil) { (meta, error)  in
            if let error = error {
                completion!(error)
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        completion!(error)
                        return
                    }
                    
                    guard let uid = result?.user.uid else {return}
                    
                    let data = ["email": credentials.email,
                                "fullname": credentials.fullname,
                                "profileImageUrl": profileImageURL,
                                "uid": uid,
                                "username": credentials.username]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                    
            
                    
                }
            }
        }
    }
}
