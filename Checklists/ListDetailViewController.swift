//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Ahmed Abdalla on 9/28/21.
//

import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show keyboard when screen appears
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        // Checks if there is a checklist to edit
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }
    
    // MARK: Actions
    @IBAction func cancel() {
        // Call delegate method
        // What happens depends on delegate implementation
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        // Attempt to unwrap checklistToEdit
        // If not nil then edit an existing checklist
        if let checklist = checklistToEdit {
            // Set new checklist name from text in text field
            checklist.name = textField.text!
            
            // Call delegate method
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        }
        // Otherwise add a new checklist
        else {
            // Create a new Checklist with name from text field
            let checklist = Checklist(name: textField.text!)
            
            // Call delegate method
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    // MARK: Table View Delegates
    // Turn off selection for cells in table view
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}

