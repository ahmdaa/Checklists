//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Ahmed Abdalla on 9/14/21.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    var lists = [Checklist]()
    
    let cellIdentifier = "ChecklistCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Register cell with identifier for table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // Add placeholder data
        var list = Checklist(name: "Birthdays")
        lists.append(list)

        list = Checklist(name: "Groceries")
        lists.append(list)

        list = Checklist(name: "Cool Apps")
        lists.append(list)

        list = Checklist(name: "To Do")
        lists.append(list)
    }

    // MARK: Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        // Update cell information
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            // Perform a typecast of sender of type any to
            // type Checklist
            controller.checklist = sender as? Checklist
        }
    }

}
