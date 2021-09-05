//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Ahmed Abdalla on 9/5/21.
//

import UIKit

class AddItemViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK:- Actions
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true) // Closing
    }
    
    @IBAction func done() {
        navigationController?.popViewController(animated: true)
    }

}
