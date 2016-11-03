//
//  GithubRepository.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubRepository {
    var fullName: String
    var htmlURL: URL
    var repositoryID: String
    
    init(dictionary: [String : Any]) {
        guard let
            name = dictionary["full_name"] as? String,
            let valueAsString = dictionary["html_url"] as? String,
            let valueAsURL = URL(string: valueAsString),
            let repoID = dictionary["id"] as? Int
            else { fatalError("Could not create repository object from supplied dictionary") }
        
        htmlURL = valueAsURL
        fullName = name
        repositoryID = String(repoID)
    }
    
}
