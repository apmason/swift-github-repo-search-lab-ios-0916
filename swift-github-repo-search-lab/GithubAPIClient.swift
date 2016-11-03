//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(_ completion: @escaping ([Any]) -> ()) {
        let githubURL = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        let url = URL(string: githubURL)
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        Alamofire.request(unwrappedURL).responseJSON { response in

            
            if let JSON = response.data {
                print("JSON worked")
                if let responseArray = try? JSONSerialization.jsonObject(with: JSON, options: []) as? [[String : Any]] {
                    print("response worked")
                    if let responseArray = responseArray {
                        print("got to completion")
                        completion(responseArray)
                    }
                }
                print("JSON: \(JSON)")
            }
        }
    }

    class func checkIfRepositoryIsStarred(fullName: String, completion: @escaping (Bool) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(fullName)"
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let header = ["Authorization": "token \(Secrets.access_token)"]
        Alamofire.request(unwrappedURL, headers: header).responseJSON { (response) in
            if response.response?.statusCode == 204 {
                print("IS STARRED SUCCESS")
                completion(true)
            }   else if response.response?.statusCode == 404 {
                print("IS NOT STARRED")
                completion(false)
            }
        }
        
    }
    
    
    class func starRepository(name: String, completion: @escaping () -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(name)"
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let httpHeader =  ["Authorization": "token \(Secrets.access_token)","Content-Length": "0"]
        Alamofire.request(unwrappedURL, method: .put, parameters: nil, headers: httpHeader).responseJSON { (response) in
            if response.response?.statusCode == 204 {
                print("star worked =)")
                completion()
            }   else {
                print("star did not work! =(")
                print(response.response?.statusCode)
                completion()
            }
        }
    }
    
    class func unstarRepository(name: String, completion: @escaping () -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(name)"
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let httpHeader =  ["Authorization": "token \(Secrets.access_token)","Content-Length": "0"]
        Alamofire.request(unwrappedURL, method: .delete, parameters: nil, headers: httpHeader).responseJSON { (response) in
            if response.response?.statusCode == 204 {
                print("unstar worked =)")
                completion()
            }   else {
                print("unstar did not work! =(")
                print(response.response?.statusCode)
                completion()
            }
        }
    }
    
    class func searchRepos(searchResult: String?, completion: @escaping ([[String: Any]]) -> ())  {
        guard let searchResult = searchResult else { fatalError("Invalid String") }
        
        let url: String? = "\(Secrets.githubAPIURL)/search/repositories?q=\(searchResult)"
        print(url)
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        print(unwrappedURL)
        Alamofire.request(unwrappedURL).responseJSON { (response) in
            
            if let data = response.data {
                print("passed data in")
                if let response = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("deserialized")
                    let items = response["items"] as! [[String: Any]]
                    print("right before completion")
                    completion(items)
                }
            }
        }
    }
}





