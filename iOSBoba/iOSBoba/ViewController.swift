//
//  ViewController.swift
//  iOSBoba
//
//  Created by Jacob Pernell on 10/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    var yelpResults = [APIResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iOS Boba v1"
        
        getData(from: YELP_URL, queryParams: ["location": "NYC", "term": "boba"])
        
    }
    
    // MARK: - Networking
    func getData(from url: String, queryParams: [String:String]) {
        let urlComp = NSURLComponents(string: url)!
        var queryItems = [URLQueryItem]()
        
        for (key, value) in queryParams {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        if !queryItems.isEmpty {
            urlComp.queryItems = queryItems
        }
        
        var request = URLRequest(url: urlComp.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(YELP_API_KEY)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(request)
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResult.self, from: data)
                }
                catch {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print("HTTP request failed: \(error)")
            }
        }
        task.resume()
    }
}
