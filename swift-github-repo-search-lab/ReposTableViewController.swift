
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion {
            OperationQueue.main.addOperation({ 
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func searchBarButton(_ sender: AnyObject) {
        let searchController = UIAlertController(title: "Search Github Repos", message: nil, preferredStyle: .alert)
        searchController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            print("submitted")
            let searchRepo = searchController.textFields![0]
            let searchText = searchRepo.text
            self.store.repositories.removeAll()
            print(self.store.repositories.count)
            GithubAPIClient.searchRepos(searchResult: searchText, completion: { (responseArray) in
                print("right after completion")
                for dictionary in responseArray {
                    self.store.repositories.append(GithubRepository(dictionary: dictionary))
                }
                self.tableView.reloadData()
            })
            
        }
        
        print("right before tableview reload")
        searchController.addAction(submitAction)
        
        present(searchController, animated: true, completion: nil)
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        print(indexPath.row)
        let repository: GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.toggleStarStatus(for: self.store.repositories[indexPath.row]) { (success) in
            print("WORKED< TOGGLE INITAITED!!!!")
        }
        store.toggleStarStatus(for: self.store.repositories[indexPath.row]) { (success) in
            if success {
                let name = self.store.repositories[indexPath.row].fullName
                let alertController = UIAlertController(title: "Starred", message: "You starred \(name)", preferredStyle: .alert)
                
                let starredAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    print("you have pressed OK button")
                }
                
                alertController.addAction(starredAction)
                self.present(alertController, animated: true, completion: nil)
            }   else {
                let name = self.store.repositories[indexPath.row].fullName
                let alertController = UIAlertController(title: "Unstarred", message: "You unstarred \(name)", preferredStyle: .alert)
                
                let starredAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    print("you have pressed OK button")
                }
                
                alertController.addAction(starredAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
     
    }
    
}
