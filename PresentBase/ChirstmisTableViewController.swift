//
//  ChirstmisTableViewController.swift
//  PresentBase
//
//  Created by Zabeehullah Qayumi on 9/12/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit
import CoreData

class ChirstmisTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    var myGift = [["name":"Best Friend", "image": "2", "item":"camera"],["name":"Best Friend", "image": "3", "item":"camera"],["name":"Best Friend", "image": "4", "item":"camera"]]

    var presents = [Present]()
    
    var managedObjectContext : NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageIcon = UIImageView(image: UIImage(named: "gift"))
        self.navigationItem.titleView = imageIcon
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        loadedItems()
    }
    
    func loadedItems(){
        let presentRequest:NSFetchRequest<Present> = Present.fetchRequest()
        
        do{
            presents = try managedObjectContext.fetch(presentRequest)
            self.tableView.reloadData()
        }catch{
            print("Could not load data \(error.localizedDescription)")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presents.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PresentTableViewCell
        
        let presentsItem = presents[indexPath.row]
        
        
        if let presentImage = UIImage(data: presentsItem.image as! Data){
            cell.backgroundImageView.image = presentImage

        }
        
        cell.nameLabel.text = presentsItem.person
        cell.itemLabel.text = presentsItem.presentName
       
        return cell
    }

   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    @IBAction func presentButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate  = self
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            picker.dismiss(animated: true, completion: {
                self.createPresentItem(with:image)
            })
        }
        
    }
    func createPresentItem(with image: UIImage){
        let presentItem = Present(context: managedObjectContext)
        presentItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!) as Data
        
        
        let inputAlert = UIAlertController(title: "New Present", message: "Enter a person and present", preferredStyle: .alert)
        inputAlert.addTextField { (texfield:UITextField) in
            texfield.placeholder = "Person"
        }
        
        inputAlert.addTextField { (texfield:UITextField) in
            texfield.placeholder = "Present"
        }
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            let personTextField = inputAlert.textFields?.first
            let presentTextField = inputAlert.textFields?.last
            
            if personTextField?.text != "" && presentTextField?.text != ""{
                presentItem.person = personTextField?.text
                presentItem.presentName = presentTextField?.text
                
                do{
                    try self.managedObjectContext.save()
                    self.loadedItems()
                }catch{
                    print("Could not save\(error.localizedDescription)")
                }
            }
            
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(inputAlert, animated: true, completion: nil)
    


}
}
