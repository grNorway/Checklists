//
//  ChecklistTableViewController.swift
//  CheckLists
//
//  Created by Panagiotis Siapkaras on 5/25/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import Foundation
import UIKit

class ChecklistTableViewController: UITableViewController , ItemDetailViewControllerDelegate{

    var items : [ChecklistItem]
    var checklist : Checklist!
    
//    var row0item : ChecklistItem
//    var row1item : ChecklistItem
//    var row2item : ChecklistItem
//    var row3item : ChecklistItem
//    var row4item : ChecklistItem
    
    required init?(coder aDecoder: NSCoder) {
        
        items = [ChecklistItem]()
        

        
        super.init(coder: aDecoder)
//        loadChecklistItems()
        
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Defaults saving
    
//    func documentsDirectory() -> URL{
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//    
//    func dataFilePath() -> URL{
//        return documentsDirectory().appendingPathComponent("CheckLists.plist")
//    }
//    
//    func saveChecklistItems(){
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: data)
//        archiver.encode(items, forKey: "ChecklistItems")
//        archiver.finishEncoding()
//        data.write(to: dataFilePath(), atomically: true)
//    }
//    
//    func loadChecklistItems(){
//        let path = dataFilePath()
//        
//        if let data = try? Data(contentsOf: path) {
//            
//            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
//            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
//            unarchiver.finishDecoding()
//        }
//    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return checklist.items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
    
        configureText(for: cell, at: item)
        configureCheckmark(for: cell, at: item)
//        saveChecklistItems()
        return cell
    }
    
    func configureCheckmark(for cell: UITableViewCell,at item: ChecklistItem){
        
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        if item.checked {
            label.text = "✓"
        }else {
            label.text = ""
        }
        
        
    }
    
    func configureText(for cell:UITableViewCell , at item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        //label.text = item.text
        label.text = "\(item.itemID) : \(item.text)"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, at: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
//        saveChecklistItems()
    }
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
//        saveChecklistItems()
        dismiss(animated: true, completion: nil)
        
    }
    
    func itemDetailViewController(_controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        
        if let index = checklist.items.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, at: item)
            }
        }
        
        dismiss(animated: true, completion: nil)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        
        if segue.identifier == "AddItem"{
            
            let navigationViewController = segue.destination as! UINavigationController
            let ItemDetailViewController = navigationViewController.topViewController as! ItemDetailViewController
            ItemDetailViewController.delegate = self
    }else if segue.identifier == "EditItem"{
            let navigationViewController = segue.destination as! UINavigationController
            let ItemDetailViewController = navigationViewController.topViewController as! ItemDetailViewController
            ItemDetailViewController.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                ItemDetailViewController.itemToEdit = checklist.items[indexPath.row]
            }
    }
    }
}
