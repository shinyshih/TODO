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
        listItems.append(item)
        CheckListItem.saveToFile(items: listItems)
        tableView.reloadData()
        
    }
    
    func createEventViewController(_ controller: CreateEventViewController, didFinishEditing item: CheckListItem) {
        controller.navigationController?.popViewController(animated: true)
        
        let indexPath = IndexPath(row: selectedRow!, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
            configureText(for: cell, with: item)
        }
        CheckListItem.saveToFile(items: listItems)
        tableView.reloadData()
        
    }
    
    var listItems = [CheckListItem]()
    var selectedImageFromPicker: UIImage?

    @IBOutlet weak var changeImageButton: UIBarButtonItem!
    
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

    // CONFIGURE CHECKMARK & TEXT
    func configureCheckmark(for cell: UITableViewCell,
                            with item: CheckListItem) {
        let checkLabel = cell.viewWithTag(1001) as? UILabel
        
        if item.checked {
            checkLabel!.text = "✔️"
        } else {
            checkLabel!.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: CheckListItem){
        let label = cell.viewWithTag(1000) as? UILabel
        label?.text = item.itemName
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

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell

        let item = listItems[indexPath.row]
        cell?.itemLabel.text = item.itemName
        configureText(for: cell!, with: item)
        configureCheckmark(for: cell!, with: item)
        // edit 不會出現值，但toggle過之後會有值，再按一次又沒有值
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = listItems[indexPath.row]
            item.toggle()
            configureCheckmark(for: cell, with: item)
        }
    }
    
   
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        CheckListItem.saveToFile(items: listItems)

    }
    
    var selectedRow: Int?
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let controller = segue.destination as? CreateEventViewController
        controller?.delegate = self
        if segue.identifier == "editSegue" {
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller?.itemToEdit = listItems[indexPath.row]
                selectedRow = indexPath.row
                print(controller?.itemToEdit )
            }
        }
    }
    

}
