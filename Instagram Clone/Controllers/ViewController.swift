//
//  ViewController.swift
//  Instagram Clone
//
//  Created by Saheb Singh Tuteja on 01/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import Fabric

class ViewController: UIViewController,LoginButtonDelegate{

    
    
    var gl : CAGradientLayer!
    @IBOutlet weak var backgroundView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        gl = createGradientLayer()
        backgroundView.layer.addSublayer(gl)
        view.addSubview(loginButton)
//        getUserInformation()
        Reusable.shared.getUserInformation()
        loginButton.frame = CGRect(x: 16, y: 575, width: view.frame.width - 32, height: 50)
        let checkLogin : Bool = UserDefaults.standard.bool(forKey: "Logged In")
        if checkLogin {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "TabbarViewController") as! UITabBarController
            navigationController?.pushViewController(homeVC, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(true)
    }

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else
        {
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        
            UserDefaults.standard.set(true, forKey: "Logged In")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabVC = storyboard.instantiateViewController(withIdentifier: "TabbarViewController") as! UITabBarController
            navigationController?.pushViewController(tabVC, animated: true)
        }
    }
    
//    func getUserInformation()
//    {
//        let user = Auth.auth().currentUser
//        print(type(of: user))
//        if let user = user {
//            UserDefaults.standard.setValue(user.displayName!, forKey: "Username")
//            //append ?type=square in the url
//            let uid = user.uid
//            let url = "http://graph.facebook.com/\(uid)/picture?type=square"
//            UserDefaults.standard.set(url, forKey: "ImageData")
//        }
//    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        UserDefaults.standard.set(false, forKey: "Logged In")
        
        print("User Logged Out Successfully")
    }

    func createGradientLayer() -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.purple.cgColor, UIColor.red.cgColor]
        return gradientLayer
    }
    
}
