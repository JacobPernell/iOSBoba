//
//  ViewController.swift
//  iOSBoba
//
//  Created by Jacob Pernell on 10/11/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    var yelpResults = [APIResult]()
    let mapView = MKMapView()
    let coordinate = CLLocationCoordinate2D(latitude: 37.3541, longitude: -121.9552)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iOS Boba v1"
        
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
        annotation.title = "SF"
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        getData(from: YELP_URL, queryParams: ["location": "NYC", "term": "boba"])
    }
    
    // MARK: - Map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
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
//                    self.annotation.coordinate = CLLocationCoordinate2D(latitude: result.businesses[0].coordinates!.latitude, longitude: result.businesses[0].coordinates!.longitude)
//                    self.annotation.coordinate = CLLocationCoordinate2D(latitude: 37, longitude: 122)
                    self.yelpResults = [result]
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
