//
//  HomeScreenController.swift
//  Instagram Clone
//
//  Created by Saheb Singh Tuteja on 01/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import Fabric
class HomeScreenController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var itemArray = [Items]()
//    var imageArray = [Images]()
    let db = Firestore.firestore()
    var deleteValue : Int = 0
    var userImage : UIImage?
   
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fifthView: UIView!
    @IBOutlet weak var itemTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        itemTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        firstView.layer.cornerRadius = firstView.frame.size.width / 2
        firstView.clipsToBounds = true
        secondView.layer.cornerRadius = secondView.frame.size.width / 2
        secondView.clipsToBounds = true
        thirdView.layer.cornerRadius = thirdView.frame.size.width / 2
        thirdView.clipsToBounds = true
        fourthView.layer.cornerRadius = fourthView.frame.size.width / 2
        fourthView.clipsToBounds = true
        fifthView.layer.cornerRadius = fifthView.frame.size.width / 2
        fifthView.clipsToBounds = true
        getData()
        itemTableView.reloadData()

        let url = Auth.auth().currentUser?.photoURL//(NSURL(string: UserDefaults.standard.object(forKey: "ImageData") as! String))! as URL
        print(type(of: url))
        if let data = try? Data(contentsOf: url!){
            if let image = UIImage(data: data){
                userImage = image
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        itemTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        getData()
        return itemArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let delete = UIButton()
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        cell.captionTextView.text = itemArray[indexPath.row].captionLabel
        cell.postedImage.image = itemArray[indexPath.row].postedImage
        cell.profileImage.image = userImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageVC.fetchedImage = itemArray[indexPath.row].postedImage
        navigationController?.pushViewController(imageVC, animated: true)
    }
    func getData()
    {
        db.collection("posts").getDocuments { (querySnapshot, err) in
            self.itemArray.removeAll()
            if let err = err{
                print("Error getting documents \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    let newItem = Items()

                    let data = (document.data()["postCaption"] as! String)
                    newItem.captionLabel = data
                    let storageRef = Storage.storage().reference(withPath: "posts/\(document.documentID).jpg")
                    storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                        if let error = error{
                            print("Error: \(error)")
                        }
                        if let data = data{
                            newItem.postedImage = UIImage(data: data)
                            print(type(of: newItem.postedImage))
                        }
                        
                    }
                    print("*******\(newItem.captionLabel)*******")
                    self.itemArray.append(newItem)
                    
                }
                self.itemTableView.reloadData()
                }
        }
        
    }
    
    @IBAction func profileSideMenuAction(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
