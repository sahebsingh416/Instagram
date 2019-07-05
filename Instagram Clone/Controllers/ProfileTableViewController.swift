//
//  ProfileTableViewController.swift
//  Instagram Clone
//
//  Created by Saheb Singh Tuteja on 03/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import MessageUI
import Fabric

class ProfileTableViewController: UITableViewController{
    
    let iconArray = [#imageLiteral(resourceName: "Home"),#imageLiteral(resourceName: "share"),#imageLiteral(resourceName: "logout")]
    let menuArray = ["Home","Share","Logout"]
    @IBOutlet weak var profilePicture: Rounded_Image!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
//        profilePicture.image = Reusable.shared.getImage()
        profileNameLabel.text = Auth.auth().currentUser?.displayName
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.menuNameLabel.text = menuArray[indexPath.row]
        cell.iconImage.image = iconArray[indexPath.row]
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(menuArray[indexPath.row])
        switch menuArray[indexPath.row] {
        case "Home":
            dismiss(animated: true, completion: nil)
            break
        case "Share":
            let alert = UIAlertController(title: "Share", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Share via Mail", style: .default, handler: { (action) in
                self.shareViaMail()
            }))
            alert.addAction(UIAlertAction(title: "Share via Message", style: .default, handler: { (action) in
                self.shareViaMessage()
            }))
            alert.addAction(UIAlertAction(title: "Share via Others", style: .default, handler: { (action) in
                self.shareViaOthers()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            break
        case "Logout":
            do{
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().currentUser?.link(with:credential,completion:nil)
                try! Auth.auth().signOut()
                Auth.auth().signInAnonymously()
                LoginManager().logOut()
                print("Logged Out Successfully")
            }catch{
                print("User Sign Out Error : \(error)")
            }
            UserDefaults.standard.set(false, forKey:"Logged In")
            self.dismiss(animated: true, completion: nil)
            navigationController?.popToRootViewController(animated: true)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
            break
            
        default:
            print("Navigation Unsuccessful")
        }
    }
    func shareViaMessage(){
        let messageComposeViewController = MFMessageComposeViewController()
        if MFMessageComposeViewController.canSendText() {
            self.present(messageComposeViewController, animated: true, completion: nil)
        }
    }
    func shareViaOthers(){
        let text = "Hello"
            let text2 = [ text ]
            let activityViewController = UIActivityViewController(activityItems: text2, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    func shareViaMail(){
        let mailComposeViewController = self.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
    }
    }
}
extension ProfileTableViewController: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        return mailComposerVC
    }
    
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let composerVC = MFMessageComposeViewController()
        composerVC.messageComposeDelegate = self
        composerVC.recipients = ["4085551212"]
        composerVC.body = "Hello from California!"
        return composerVC
    }
}
