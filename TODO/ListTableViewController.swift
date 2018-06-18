//
//  ListTableViewController.swift
//  TODO
//
//  Created by 施馨檸 on 2018/6/15.
//  Copyright © 2018 施馨檸. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CreateEventViewControllerDelegate {
    
    func createEventViewControllerDidCancel(_ controller: CreateEventViewController) {
        controller.navigationController?.popViewController(animated: true)
        
    }
    
    func createEventViewController(_ controller: CreateEventViewController, didFinishAdding item: CheckListItem) {
        controller.navigationController?.popViewController(animated: true)
    }
    

    var listItems = [CheckListItem]()
    var selectedImageFromPicker: UIImage?

    @IBOutlet weak var changeImageButton: UIBarButtonItem!
    func add(item: CheckListItem) {
        listItems.append(item)
        CheckListItem.saveToFile(items: listItems)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imagepicker 的東西還沒有savetofile
        if selectedImageFromPicker == nil {
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        } else {
            self.tableView.backgroundView = UIImageView(image: selectedImageFromPicker)
        }
        

        self.tableView.backgroundView?.alpha = 0.5
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        if let items = CheckListItem.readItemsFromFile() {
            listItems = items
        }
    }

    // CHECKMARK TOGGLE
    func checkMarkState(cell: UITableViewCell, with item: CheckListItem) {
        
    }
    
    // BACKGROUND IMAGE CHANGE
    @IBAction func changeBackgroundImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
        }
        
        self.tableView.backgroundView = UIImageView(image: selectedImageFromPicker)
        self.tableView.backgroundView?.contentMode = .scaleAspectFill

        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)

        let item = listItems[indexPath.row]
        cell.textLabel?.text = item.itemName

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            listItems.remove(at: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as? CreateEventViewController
        controller?.listTableViewController = self
    }
    

}
