//
//  HeroListControllerTableViewController.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/2.
//

import UIKit
import CoreData

let kSelectedTabDefaultKey = "Selected Tab"

enum tabBarKeys: Int {
    case ByName
    case BySecretIdentity
}

class HeroListController: UITableViewController, UITabBarDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var heroTableView: UITableView!
    @IBOutlet weak var heroTabBar: UITabBar!
    
    private var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航栏
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        let addBtnItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.insertHero))
        self.navigationItem.leftBarButtonItem = addBtnItem
        
        // 底Tab
        let defaults = UserDefaults.standard
        let selectTab = defaults.integer(forKey: kSelectedTabDefaultKey)
        let item = heroTabBar.items![selectTab] as UITabBarItem
        heroTabBar.selectedItem = item
        heroTabBar.delegate = self
        
        // 表格
        heroTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HeroListCell")
        
        // 获取请求
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let title = NSLocalizedString("Error Fetch Entity", comment: "Error Fetch Entity")
            let nserror = error as NSError
            let message = String(format: "Unresolved error %@, %@", nserror, nserror.userInfo)
            self.showAlertWithCompletion(title: title, message: message, ButtonTitle: "Aw nuts", completion: {_ in exit(-1)})
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HeroListCell"
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)

        // Configure the cell...
        let aHero = fetchedResultsController.object(at: indexPath) as! NSManagedObject
        let tableArray = self.heroTabBar.items as NSArray?
        let tab = tableArray?.index(of: self.heroTabBar.selectedItem!)
        
        switch (tab) {
        case tabBarKeys.ByName.rawValue:
            cell.textLabel?.text = aHero.value(forKey: "name") as? String
            cell.detailTextLabel?.text = aHero.value(forKey: "secretIdentity") as? String
        case tabBarKeys.BySecretIdentity.rawValue:
            cell.textLabel?.text = aHero.value(forKey: "secretIdentity") as? String
            cell.detailTextLabel?.text = aHero.value(forKey: "name") as? String
        default:
            ()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHero = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
        self.performSegue(withIdentifier: "jumpToDetail", sender: selectedHero)
    }
    
    // 该方法由performSegue withIdentifier 内部调用
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "jumpToDetail" {
            return
        }
        if let _ = sender as? NSManagedObject {
            let detailController: HeroDetailController = segue.destination as! HeroDetailController
            detailController.hero = sender as? NSManagedObject
        } else {
            let title = NSLocalizedString("Hero Detail Error", comment: "Hero Detail Error")
            let message = NSLocalizedString("Error trying to show Hero detail", comment: "Error trying to show Hero detail")
            self.showAlertWithCompletion(title: title, message: message, ButtonTitle: "Aw nuts", completion: {_ in exit(-1)})
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let managedObjectContext = fetchedResultsController.managedObjectContext as NSManagedObjectContext

        if editingStyle == .delete {
            // Delete the row from the data source
            managedObjectContext.delete(fetchedResultsController.object(at: indexPath) as! NSManagedObject)
            do {
                try managedObjectContext.save()
            } catch {
                let title = NSLocalizedString("Error Saving Entity", comment: "Error Saving Entity")
                let nserror = error as NSError
                let message = String(format: "Unresolved error %@, %@", nserror, nserror.userInfo)
                self.showAlertWithCompletion(title: title, message: message, ButtonTitle: "Aw nuts", completion: {_ in exit(-1)})
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - UITabBarDelegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)  {
        let defaults = UserDefaults.standard
        let items = heroTabBar.items!
        let tabIndex = items.firstIndex(of: item)
        defaults.set(tabIndex, forKey: kSelectedTabDefaultKey)
        
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Hero")
        _fetchedResultsController = nil;
        
        do {
            try fetchedResultsController.performFetch()
            self.heroTableView.reloadData()
        } catch {
            let title = NSLocalizedString("Error Fetch Entity", comment: "Error Fetch Entity")
            let nserror = error as NSError
            let message = String(format: "Unresolved error %@, %@", nserror, nserror.userInfo)
            self.showAlertWithCompletion(title: title, message: message, ButtonTitle: "Aw nuts", completion: {_ in exit(-1)})
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.heroTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.heroTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch (type) {
        case .insert:
            self.heroTableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            self.heroTableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            self.heroTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.heroTableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            self.heroTableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        }
    }
    
    // MARK: - Action
    @objc func insertHero() {
        let managedObjectContext = fetchedResultsController.managedObjectContext as NSManagedObjectContext
        let entity: NSEntityDescription = fetchedResultsController.fetchRequest.entity!
        let newHero = NSEntityDescription.insertNewObject(forEntityName: entity.name!, into: managedObjectContext)
        
        do {
            try managedObjectContext.save()
            self.performSegue(withIdentifier: "jumpToDetail", sender: newHero)
        } catch {
            self.showAlertWithCompletion(title: "title", message: "message", ButtonTitle: "Aw nuts", completion: {_ in exit(-1)})
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // 编辑时禁用+号
        self.navigationItem.leftBarButtonItem?.isEnabled = !editing
        heroTableView.setEditing(editing, animated: animated)
    }
    
    // MARK: - Private
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        get {
            if _fetchedResultsController != nil {
                return _fetchedResultsController
            }
            // 获取请求
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Hero", in: context)
            fetchRequest.entity = entity
            fetchRequest.fetchBatchSize = 20
            
            let array = self.heroTabBar.items
            var tabIndex = array?.firstIndex(of: self.heroTabBar.selectedItem!)
            if tabIndex == NSNotFound {
                let defaults = UserDefaults.standard
                tabIndex = defaults.integer(forKey: kSelectedTabDefaultKey)
            }
            
            // 设置获取请求的排序描述符
            var sectionKey : String!
            let sortDescriptor1 = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: "secretIdentity", ascending: true)
            switch (tabIndex) {
            case tabBarKeys.ByName.rawValue:
                let sortDescriptors = [sortDescriptor1, sortDescriptor2]
                fetchRequest.sortDescriptors = sortDescriptors
                sectionKey = "name"
            case tabBarKeys.BySecretIdentity.rawValue:
                let sortDescriptors = [sortDescriptor2, sortDescriptor1]
                fetchRequest.sortDescriptors = sortDescriptors
                sectionKey = "secretIdentity"
            default:
                ()
            }
            
            // 获取结果控制器
            let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionKey, cacheName: "Hero")
            aFetchedResultsController.delegate = self
            _fetchedResultsController = aFetchedResultsController
            return _fetchedResultsController
        }
    }
    
    func showAlertWithCompletion(title: String, message: String, ButtonTitle: String = "OK", completion:((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: ButtonTitle, style: .default, handler: completion)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

}
