//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(_ completion: @escaping () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
            }
            completion()
        }
    }

    func toggleStarStatus(for repo: GithubRepository, completion: @escaping (Bool) -> ()) {
        let name = repo.fullName
        GithubAPIClient.checkIfRepositoryIsStarred(fullName: name) { (success) in
            if success {
                GithubAPIClient.unstarRepository(name: name, completion: { 
                    print("Toggle worked, unstarred")
                    completion(false)
                })
            }   else {
                GithubAPIClient.starRepository(name: name, completion: { 
                    print("Toggle worked, starred")
                    completion(true)
                })
            }
        }
    }
    
    
    
    
}

