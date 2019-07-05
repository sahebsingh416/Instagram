//
//  Reusable.swift
//  Instagram Clone
//
//  Created by Saheb Singh Tuteja on 05/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import MessageUI

class Reusable{
    
    static let shared = Reusable()
    let db = Firestore.firestore()
    func getUserInformation()
    {
        let user = Auth.auth().currentUser
        print(type(of: user))
        if let user = user {
            UserDefaults.standard.setValue(user.displayName!, forKey: "Username")
            UserDefaults.standard.set(user.photoURL, forKey: "photoURL")
            UserDefaults.standard.setValue(user.email, forKey: "userEmail")
            UserDefaults.standard.setValue(user.phoneNumber, forKey: "userPhoneNumber")
        }
    }
    
    func getImage() -> UIImage {
        var defaultImage = UIImage()
        let url = Auth.auth().currentUser?.photoURL//(NSURL(string: UserDefaults.standard.object(forKey: "ImageData") as! String))! as URL
        print(type(of: url))
        if let data = try? Data(contentsOf: url!){
            if let image = UIImage(data: data){
                defaultImage = image
            }
        }
        else{
            defaultImage =  UIImage(named: "question")!
        }
        return defaultImage
    }
}


