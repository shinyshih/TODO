//
//  CreateEventViewController.swift
//  TODO
//
//  Created by 施馨檸 on 2018/6/15.
//  Copyright © 2018 施馨檸. All rights reserved.
//

import UIKit

protocol CreateEventViewControllerDelegate: class {
    func createEventViewControllerDidCancel(_ controller: CreateEventViewController)
    func createEventViewController(_ controller: CreateEventViewController, didFinishAdding item: CheckListItem)
    func createEventViewController(_ controller: CreateEventViewController, didFinishEditing item: CheckListItem)
}

class CreateEventViewController: UIViewController {

    @IBOutlet weak var addItemTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    weak var delegate: CreateEventViewControllerDelegate?
    var itemToEdit: CheckListItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = ""
            addItemTextField.text = item.itemName
        }
        
        updateUploadButtonState()
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if let itemToEdit = itemToEdit {
            itemToEdit.itemName = addItemTextField.text!
            delegate?.createEventViewController(self, didFinishEditing: itemToEdit)
        } else {
            let item = CheckListItem()
            item.itemName = addItemTextField.text
            item.checked = false
            delegate?.createEventViewController(self, didFinishAdding: item)
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.createEventViewControllerDidCancel(self)
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateUploadButtonState()
    }
    
    func updateUploadButtonState() {
        let addItemText = addItemTextField.text ?? ""
        doneButton.isEnabled = !addItemText.isEmpty
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
