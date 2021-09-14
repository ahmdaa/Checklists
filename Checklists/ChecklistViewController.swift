//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Ahmed Abdalla on 9/5/21.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var items = [ChecklistItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Load items
        loadChecklistItems()
        
        // print("Documents folder is \(documentsDirectory())")
        // print("Data file path is \(dataFilePath())")
    }
    
    // MARK:- Actions
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK:- Table View Data Source
    // override because TableViewController already has the methods
    // _ means no external parameter name.
    // External parameter name - Internal parameter name
    // numberOfRowsInSection   - section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
    
    // Enable swipe to delete.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
    }
    
    // MARK:- Add Item View Controller Delegates
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        
        // Store new row in temporary array.
        let indexPaths = [indexPath]
        
        // Insert new row (or rows) in the table view.
        // .automatic parameter animates the insertion.
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    // MARK:- Data Storage
    // Returns URL path to the Documents folder for the app.
    // iOS uses URLS to refer to files in its filesystem.
    // Format: file://URL
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Returns full URL path to the Property List (.plist) file for storing data.
    func dataFilePath() -> URL {
        documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // Serialization method
    // Retrieves the contents of the items array, converts it to a block of binary data, and then writes this data to a file.
    func saveChecklistItems() {
        // Create an instance of PropertyListEncoder which will encode the items array, and all the ChecklistItems in it, into a binary data format that can be written to a file.
        let encoder = PropertyListEncoder()
        
        // The do keyword sets up a block of code to catch Swift errors. Swift handles errors under certain conditions by throwing an error. In such cases, you need a block of code to catch the error and to handle it. The do keyword indicates the start of such a block.
        do {
            // The encoder you created earlier is used to try to encode the items array. The encode method throws a Swift error if it is unable to encode the data for some reason — for example, the data is not in the expected format, or it is corrupted etc. The try keyword indicates that the call to encode can fail and if that happens, that it will throw an error.
            let data = try encoder.encode(items)
            
            // If the data constant was successfully created by the call to encode in the previous line, then you write the data to a file using the file path returned by a call to dataFilePath(). Note that the write method also can throw an error.
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        // The catch statement indicates the block of code to be executed if an error was thrown by any line of code in the enclosing do block.
        } catch {
            // Handle the caught error. Simply print out an error message. Local variable error is populated automatically by Swift and it contains the error thrown by one of the statements within the do block.
            print("Error encoding item array:\(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        // Get URL path to data file and store in path.
        let path = dataFilePath()
        // Load the contents of Checklists.plist into a new Data object. The try? command attempts to create the Data object, but returns nil if it fails.
        if let data = try? Data(contentsOf: path) {
            // Create a decoder instance.
            let decoder = PropertyListDecoder()
            do {
                // Load the saved data back into items using the decoder's decode method. The only item of interest here would be the first parameter passed to decode. The decoder needs to know what type of data will be the result of the decode operation and you let it know by indicating that it will be an array of ChecklistItem objects.
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}

