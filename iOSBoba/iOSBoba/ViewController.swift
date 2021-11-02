//
//  ViewController.swift
//  iOSBoba
//
//  Created by Jacob Pernell on 10/11/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var yelpResults = [APIResult]()
    let mapView = MKMapView()
    let annotation = MKPointAnnotation()
    var locationManager = CLLocationManager()
    var userCoordinates = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iOS Boba v1"
        
        locationManager.delegate = self
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        view.addSubview(mapView)
        mapView.frame = view.bounds
        
//        getData(from: YELP_URL, queryParams: ["location": "NYC", "term": "boba"])
        
        
    }
    
    // MARK: - User Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            if !yelpResults.isEmpty { // TODO: - Try to update the map only after the api call happens
                userCoordinates = CLLocationCoordinate2D(latitude: yelpResults[0].businesses[0].coordinates!.latitude, longitude: yelpResults[0].businesses[0].coordinates!.longitude)
            }
            mapView.setRegion(MKCoordinateRegion(center: userCoordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
            updateAnnotation()
            print("long: \(longitude)")
            print("lat: \(latitude)")
        }
    }
    
    func updateAnnotation() {
        self.annotation.title = "lat: \(userCoordinates.latitude) // long: \(userCoordinates.longitude)"
        self.annotation.coordinate = userCoordinates
        mapView.addAnnotation(self.annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("LOC AUTH: when in use")
            break
        case .authorizedAlways:
            print("LOC AUTH: always")
            break
        default:
            print("default switch")
        }
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
            print("API request: \(request)")
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResult.self, from: data)
//                    self.annotation.coordinate = CLLocationCoordinate2D(latitude: result.businesses[0].coordinates!.latitude, longitude: result.businesses[0].coordinates!.longitude)
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
