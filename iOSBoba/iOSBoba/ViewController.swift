//
//  ViewController.swift
//  iOSBoba
//
//  Created by Jacob Pernell on 10/11/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iOS Boba v1"
        
        getData(from: YELP_URL)
        
    }
    
    // MARK: - Networking
    func getData(from url: String) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(YELP_API_KEY)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            print(request)
            if let data = data {
                print(data)
                if let result = try? JSONDecoder().decode(APIResult.self, from: data) {
                    print(result)
                } else {
                    print("Invalid response")
                }
            } else if let error = error {
                print("HTTP request failed: \(error)")
            }
        }
        task.resume()
    }
}
