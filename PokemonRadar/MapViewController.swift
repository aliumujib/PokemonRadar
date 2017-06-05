//
//  ViewController.swift
//  PokemonRadar
//
//  Created by Abdul-Mujib Aliu on 6/2/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation
import MapKit
import GooglePlaces
import Alamofire
import MapboxDirections
import MapboxNavigation
import Xia
import Parse

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate, PokemonSelectedDelegate, UISearchBarDelegate {

    @IBOutlet weak var pokeMonImage: UIImageView!
    
    @IBOutlet weak var pokemonName: UILabel!
    
    @IBOutlet weak var pokeMonLocation: UILabel!
    
    @IBOutlet weak var directionsButton: UIButton!
    
    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var placePhoto: UIImageView!
    
    @IBOutlet weak var pokeBall: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    var annotations: [CustomAnnotation]!
    var destination : Waypoint!
    var origin : Waypoint!
    var route : Route!

    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var locationManager : CLLocationManager!
    
    var mapHasOnceCentered: Bool = false
    var placesClient: GMSPlacesClient!
    
    
    @IBAction func searchBarButton(_ sender: Any) {
        revealSearchBar()
    }
    
    
    @IBAction func detailsBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "About", message: "PokemonRadar \n Copyright Aliu Abdul- Mujib O.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "CLOSE", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func alignment() {
        mapView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - (self.navigationController?.navigationBar.frame.size.height)!)
        
//        cardView.frame = CGRect(x: 16, y: screenHeight - cardView.frame.size.height - 72 - 16, width: screenWidth - 32, height: screenWidth/2.2) ///for shwoing cardview later
        
        cardView.frame = CGRect(x: 16, y: screenHeight + 16, width: screenWidth - 32, height: screenWidth/2.2)
        
        searchBar.frame = CGRect(x: 0, y: -200, width: screenWidth, height: 40)
        
        placePhoto.layer.cornerRadius = 3
        placePhoto.frame = CGRect(x: cardView.frame.origin.x + cardView.frame.size.width/2 - 16, y: 0, width: cardView.frame.size.width/2, height: screenWidth/2.2)
        
        pokeMonImage.frame = CGRect(x: cardView.frame.origin.x + pokeMonImage.frame.size.width/2 - 8, y: 0, width: screenWidth/5, height: screenWidth/5)
        
        pokemonName.frame = CGRect(x: 16, y:  (screenWidth/5) + 0, width: cardView.frame.size.width/2 - 32, height: 18)
        
        pokeMonLocation.frame = CGRect(x:16, y: (screenWidth/5) + 18 + 5, width: cardView.frame.size.width/2 - 32, height: 25)
        
        directionsButton.layer.cornerRadius = 3
        directionsButton.frame = CGRect(x: 16, y: (screenWidth/5) + 18 + 25 + 20, width: cardView.frame.size.width/2 - 32, height: 22)
        //cardView.isHidden = true
        
        pokeBall.frame = CGRect(x: screenWidth - (screenWidth/2) - ((screenWidth/5)/2), y: screenHeight - (screenWidth/5) - (self.navigationController?.navigationBar.frame.height)! - 32 , width: screenWidth/5, height: screenWidth/5)
        
        
        cancelButton.frame = CGRect(x: screenWidth - (30 + 32), y: 0, width: 30, height: 30) //x = screenwifht - 30 + 32
        
        print("POKE \(pokemonName.frame.size.width) \(pokemonName.frame.size.height) \(pokemonName.frame.midX)")
        print("PLACE \(pokeMonLocation.frame.size.width) \(pokeMonLocation.frame.size.height)")
        print("CARD \(directionsButton.frame.size.width) \(directionsButton.frame.size.height)")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Find them all"
        
        screenWidth = self.view.frame.size.width
        screenHeight = self.view.frame.size.height

        locationManager = CLLocationManager()
        getLocation()
        alignment()
        
        annotations = [CustomAnnotation]()
        
        mapView.delegate = self
        locationManager.delegate = self
        searchBar.delegate = self
        
    }
    
    func getLocation()  {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
            centerMapOnLocation(location: locationManager.location!)
            getPokemonSightings(queryString: "", useSearchQuery: false)
        }else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse){
            mapView.showsUserLocation = true
            centerMapOnLocation(location: manager.location!)
            placesClient = GMSPlacesClient()
        }
    }
  
    func centerMapOnLocation(location: CLLocation)  {
        _ = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)

       
        mapView.setCenter(location.coordinate, zoomLevel: 12, animated: true)
        print(location.coordinate)
        //mapView.setCe
        //(cordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        if let location = userLocation?.location{
            if(!mapHasOnceCentered){
                centerMapOnLocation(location: location)
                mapHasOnceCentered = true
            }
        }
    }
    
    var pokeArray = [2 , 3 , 4 , 5 , 8 , 33 , 25 , 77]
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        var annotationView: CustomAnnotationView?
        
        
        if  let annotationVal = annotation as? CustomAnnotation{
        
            let reuseIdentifier = "REUSE ID \(annotationVal.pokeId)"
            
            let pokeId = annotationVal.pokeId
            
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView{
                annotationView.backgroundColor = UIColor.clear
                annotationView.bindPokeMonImage(id: pokeId)

            }else{
                annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
                annotationView?.backgroundColor = UIColor.clear
                annotationView?.bindPokeMonImage(id: pokeId)
                
                print("No view to deque men")
            }
        }else{
            print("Unable to cast as CustomAnnotation")
        }
        
        return annotationView

    }
    
    
    @IBAction func closeDetailView(_ sender: Any) {
        cardView.frame = CGRect(x: 16, y: screenHeight + 16, width: screenWidth - 32, height: screenWidth/2.2)
        self.view.endEditing(true)
        hideSearchBar()
    }
    
    func savePokemonSightings(cordinate: CLLocationCoordinate2D, pokeId: Int) {
        let object = PFObject(className: PARSE_POKEMON_SIGHTING_TABLE_NAME)
        object[PARSE_POKEMON_SIGHTING_POKEMON_NAME] = pokemon[pokeId]
        object[PARSE_POKEMON_SIGHTING_POKEMON_ID] = pokeId
        let location: PFGeoPoint = PFGeoPoint(latitude: cordinate.latitude, longitude: cordinate.longitude)
        object[PARSE_POKEMON_SIGHTING_LOCATION] = location
        object.saveEventually()
    }
    
    func placeAnnotation(cordinate: CLLocationCoordinate2D, pokeId: Int) {
        let point = CustomAnnotation()
        point.coordinate = cordinate
        point.setPokeID(pokeId: pokeId)
        point.title = pokemon[pokeId]
        annotations.append(point)
        mapView.addAnnotation(point)
    }
    
    func removeAllAnnotations() {
        
        guard let annotations = mapView.annotations else { return print("Annotations Error") }
        
        if annotations.count != 0 {
            for annotation in annotations {
                mapView.removeAnnotation(annotation)
            }
        } else {
            return
        }
    }
    
    func getPokemonSightings(queryString: String, useSearchQuery : Bool) {
        let query = PFQuery(className: PARSE_POKEMON_SIGHTING_TABLE_NAME)
        if(useSearchQuery){
            query.whereKey(PARSE_POKEMON_SIGHTING_POKEMON_NAME, contains: queryString)
        }
        query.findObjectsInBackground { (objects, error) in
            if error == nil{
                self.removeAllAnnotations()
                if !(objects?.isEmpty)!{
                    for object in objects!{
                        let name = object[PARSE_POKEMON_SIGHTING_POKEMON_NAME] as? String
                        let pokeID = object[PARSE_POKEMON_SIGHTING_POKEMON_ID] as? Int
                        let cordinate : CLLocationCoordinate2D!
                        
                        if let geopoint = object[PARSE_POKEMON_SIGHTING_LOCATION] as? PFGeoPoint{
                            cordinate = CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
                            self.placeAnnotation(cordinate: cordinate, pokeId: pokeID!)
                        }
                        
                    }
                }
            }else{
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pokeBallIconClicked(_ sender: UIButton) {
        performSegue(withIdentifier: SHOW_SELECTOR_SEGUE, sender: nil)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SelectorCollectionViewController{
            dest.delegate = self
        }
    }
    
    func setSelectedPokemon(pokeId: Int) {
        let location = CLLocationCoordinate2D(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        placeAnnotation(cordinate: location, pokeId: pokeId)
        savePokemonSightings(cordinate: location, pokeId: pokeId)
    }
    
    
    func getPlaceData(placeID: String) {
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            
            if let address = place.formattedAddress{
                self.pokeMonLocation.text = address
            }
        })
    }
    
    func getPlacePhoto(placeID: String){
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }else{
                    Xia.showWarning("No image found")
                }
            }
        }
    }
    
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.placePhoto.image = photo;
            }
        })
    }
    
    
    
    func getPlaceID(completed: @escaping RequestCompleted , url : String) {
        Alamofire.request(url).responseJSON{
            response in
            
            if let result  = response.result.value as? Dictionary<String, Any>{
            
            if let mainDict = result["results"] as? [Dictionary<String, Any>]{
                if !mainDict.isEmpty{
                    if let placeID = mainDict[0]["place_id"]{
                        self.getPlacePhoto(placeID: placeID as! String)
                    }
                    if let address = mainDict[0]["formatted_address"] as? String{
                        self.pokeMonLocation.text = address
                    }
                    
                }
            }
                completed()
            }
        }
        
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        if let annotationView = annotationView as? CustomAnnotationView{
        cardView.frame = CGRect(x: 16, y: screenHeight - cardView.frame.size.height - 72 - 16, width: screenWidth - 32, height: screenWidth/2.2)
        pokeMonImage.image = UIImage(named: "\(annotationView.pokeId+1)")
        pokemonName.text = annotationView.pokeName.capitalized
        pokeMonLocation.text = "Loading location"
        placePhoto.image = UIImage(named: "photo")
        let progressHUD = LoadingView(text: "Loading Photo")
        progressHUD.center = placePhoto.center
        placePhoto.addSubview(progressHUD)
        print(getReverseGeoCodeURL(cordinate: (annotationView.annotation?.coordinate)!))
            
            getPlaceID(completed: {
                progressHUD.hide()
            }, url: getReverseGeoCodeURL(cordinate: (annotationView.annotation?.coordinate)!))
            
        }
        
        origin = Waypoint(coordinate: (locationManager.location?.coordinate)!)
        destination = Waypoint(coordinate: (annotationView.annotation?.coordinate)!)
        
        
        initDirections(origin: origin, destination: destination)

        
    }
    
    @IBAction func view_DirectionsBtnTapped(_ sender: Any) {
        let options = RouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        options.routeShapeResolution = .full
        options.includesSteps = true
        
        Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first
                else { return }
            
            
            if route.coordinateCount > 0 {
                var routeCoordinates = route.coordinates!
                let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                
                self.mapView.addAnnotation(routeLine)
                self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
            }
            
            let viewController = NavigationViewController(for: route)
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return PRIMARY_COLOR
    }
    
    func initDirections(origin: Waypoint, destination: Waypoint)  {
        
        let options = RouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        options.routeShapeResolution = .full
        options.includesSteps = true
        
        Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first
                else { return }
            
            
            if route.coordinateCount > 0 {
                var routeCoordinates = route.coordinates!
                let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                
                self.mapView.addAnnotation(routeLine)
                self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "" || searchText == nil){
            self.view.endEditing(true)
            hideSearchBar()
            getPokemonSightings(queryString: "", useSearchQuery: false)
        }else{
            
        }
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getPokemonSightings(queryString: (searchBar.text?.lowercased())!, useSearchQuery: true)
        view.endEditing(true)
        hideSearchBar()
    }

    func hideSearchBar()  {
        searchBar.frame = CGRect(x: 0, y: -200, width: screenWidth, height: 40)
    }
    
    func revealSearchBar()  {
        searchBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 40)
    }
    

}

