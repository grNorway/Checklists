//
//  AllListsViewController.swift
//  CheckLists
//
//  Created by Panagiotis Siapkaras on 5/29/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController , ListDetailViewControllerDelegate , UINavigationControllerDelegate{

//    var lists: [Checklist]
//    
//    required init?(coder aDecoder: NSCoder) {
//        
//        lists = [Checklist]()
//        
//        super.init(coder: aDecoder)
//        print("\(dataodel.dataFilePath())")
//        print("\(documentsDirectory())")
//        loadChecklists()
//        
//        
//    }

    var dataModel : DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(dataModel.dataFilePath())")
        print("\(dataModel.documentsDirectory())")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewDidAppear")
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklistRow
        print("index: \(index)   dataModel.list.count: \(dataModel.lists.count)")
        if index >= 0 && index < dataModel.lists.count  {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    
    
    //MARK: - User Defaults saving
    
//    func documentsDirectory() -> URL{
//        
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//    
//    func dataFilePath() -> URL{
//        return documentsDirectory().appendingPathComponent("Checklists.plist")
//    }
//    
//    func saveChecklists(){
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: data)
//        archiver.encode(lists, forKey: "Checklists")
//        archiver.finishEncoding()
//        data.write(to: dataFilePath(), atomically: true)
//    }
//    
//    func loadChecklists(){
//        let path = dataFilePath()
//        
//        if let data = try? Data(contentsOf: path){
//            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
//            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
//            unarchiver.finishDecoding()
//        }
//    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var remaining : String!
        if dataModel.lists[indexPath.row].items.count == 0 {
            remaining = "(No items)"
        }else {
            remaining = dataModel.lists[indexPath.row].CountUnchecked() == 0 ? "All Done!" : "\(dataModel.lists[indexPath.row].CountUnchecked()) remaining"
        }
        let cell = makeCell(for: tableView)
        let checklist = dataModel.lists[indexPath.row]
        cell.imageView?.image = UIImage(named: checklist.iconName)
        cell.textLabel!.text = checklist.name
        cell.detailTextLabel?.text = remaining
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell{
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            return cell
        }else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedChecklistRow = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let ListDetailsViewController = navigationController.visibleViewController as! ListDetailViewController
        
        ListDetailsViewController.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        ListDetailsViewController.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        
    }
    

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
    
    //MARK: - Delegate ListDetailViewController
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
//        let index = dataModel.lists.count
//        let indexPath = IndexPath(row: index, section: 0)
//        tableView.insertRows(at: [indexPath], with: .fade)
        tableView.reloadData()
        dataModel.sortChecklists()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        
//        if let index = dataModel.lists.index(of: checklist){
//        let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath){
//            cell.textLabel?.text = checklist.name
//            }
//        }
        tableView.reloadData()
        dataModel.sortChecklists()
        dismiss(animated: true, completion: nil)
    }

    
    //MARK: - UINavigationController Delegate functions
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("Navigation willshow run")
        if viewController === self{
            dataModel.indexOfSelectedChecklistRow = -1
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let ChecklistTableViewController = segue.destination as! ChecklistTableViewController
                ChecklistTableViewController.checklist = sender as! Checklist
        }else if segue.identifier == "AddChecklist"{
            let navigationController = segue.destination as! UINavigationController
            let ListDetailViewController = navigationController.visibleViewController as! ListDetailViewController
            ListDetailViewController.delegate = self
            ListDetailViewController.checklistToEdit = nil
        }
    }
    
    
    

}
