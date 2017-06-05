import Polyline

/**
 A `Route` object defines a single route that the user can follow to visit a series of waypoints in order. The route object includes information about the route, such as its distance and expected travel time. Depending on the criteria used to calculate the route, the route object may also include detailed turn-by-turn instructions.
 
 Typically, you do not create instances of this class directly. Instead, you receive route objects when you request directions using the `Directions.calculate(_:completionHandler:)` method. However, if you use the `Directions.urlForCalculating(_:)` method instead, you can pass the results of the HTTP request into this class’s initializer. 
 */
@objc(MBRoute)
open class Route: NSObject, NSSecureCoding {
    // MARK: Creating a Route
    
    internal init(routeOptions: RouteOptions, legs: [RouteLeg], distance: CLLocationDistance, expectedTravelTime: TimeInterval, coordinates: [CLLocationCoordinate2D]?) {
        self.routeOptions = routeOptions
        self.legs = legs
        self.distance = distance
        self.expectedTravelTime = expectedTravelTime
        self.coordinates = coordinates
    }
    
    /**
     Initializes a new route object with the given JSON dictionary representation and waypoints.
     
     This initializer is intended for use in conjunction with the `Directions.urlForCalculating(_:)` method.
     
     - parameter json: A JSON dictionary representation of the route as returned by the Mapbox Directions API.
     - parameter waypoints: An array of waypoints that the route visits in chronological order.
     - parameter routeOptions: The `RouteOptions` used to create the request.
     */
    public convenience init(json: [String: Any], waypoints: [Waypoint], routeOptions: RouteOptions) {
        // Associate each leg JSON with a source and destination. The sequence of destinations is offset by one from the sequence of sources.
        let legInfo = zip(zip(waypoints.prefix(upTo: waypoints.endIndex - 1), waypoints.suffix(from: 1)),
                          json["legs"] as? [JSONDictionary] ?? [])
        let legs = legInfo.map { (endpoints, json) -> RouteLeg in
            RouteLeg(json: json, source: endpoints.0, destination: endpoints.1, profileIdentifier: routeOptions.profileIdentifier)
        }
        let distance = json["distance"] as! Double
        let expectedTravelTime = json["duration"] as! Double
        
        var coordinates: [CLLocationCoordinate2D]?
        switch json["geometry"] {
        case let geometry as JSONDictionary:
            coordinates = CLLocationCoordinate2D.coordinates(geoJSON: geometry)
        case let geometry as String:
            coordinates = decodePolyline(geometry, precision: 1e5)!
        default:
            coordinates = nil
        }
        
        self.init(routeOptions: routeOptions, legs: legs, distance: distance, expectedTravelTime: expectedTravelTime, coordinates: coordinates)
    }
    
    public required init?(coder decoder: NSCoder) {
        let coordinateDictionaries = decoder.decodeObject(of: [NSArray.self, NSDictionary.self, NSString.self, NSNumber.self], forKey: "coordinates") as? [[String: CLLocationDegrees]]
        coordinates = coordinateDictionaries?.flatMap({ (coordinateDictionary) -> CLLocationCoordinate2D? in
            if let latitude = coordinateDictionary["latitude"],
                let longitude = coordinateDictionary["longitude"] {
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                return nil
            }
        })
        
        legs = decoder.decodeObject(of: [NSArray.self, RouteLeg.self], forKey: "legs") as? [RouteLeg] ?? []
        distance = decoder.decodeDouble(forKey: "distance")
        expectedTravelTime = decoder.decodeDouble(forKey: "expectedTravelTime")
        
        guard let options = decoder.decodeObject(of: [RouteOptions.self], forKey: "routeOptions") as? RouteOptions else {
            return nil
        }
        routeOptions = options
    }
    
    open static var supportsSecureCoding = true
    
    public func encode(with coder: NSCoder) {
        let coordinateDictionaries = coordinates?.map { [
            "latitude": $0.latitude,
            "longitude": $0.longitude,
        ] }
        coder.encode(coordinateDictionaries, forKey: "coordinates")
        
        coder.encode(legs, forKey: "legs")
        coder.encode(distance, forKey: "distance")
        coder.encode(expectedTravelTime, forKey: "expectedTravelTime")
        coder.encode(routeOptions, forKey: "routeOptions")
    }
    
    // MARK: Getting the Route Geometry
    
    /**
     An array of geographic coordinates defining the path of the route from start to finish.
     
     This array may be `nil` or simplified depending on the `routeShapeResolution` property of the original `RouteOptions` object.
     
     Using the [Mapbox iOS SDK](https://www.mapbox.com/ios-sdk/) or [Mapbox macOS SDK](https://github.com/mapbox/mapbox-gl-native/tree/master/platform/macos/), you can create an `MGLPolyline` object using these coordinates to display an overview of the route on an `MGLMapView`.
     */
    open let coordinates: [CLLocationCoordinate2D]?
    
    /**
     The number of coordinates.
     
     The value of this property may be zero or reduced depending on the `routeShapeResolution` property of the original `RouteOptions` object.
     
     - note: This initializer is intended for Objective-C usage. In Swift code, use the `coordinates.count` property.
     */
    open var coordinateCount: UInt {
        return UInt(coordinates?.count ?? 0)
    }
    
    /**
     Retrieves the coordinates.
     
     The array may be empty or simplified depending on the `routeShapeResolution` property of the original `RouteOptions` object.
     
     Using the [Mapbox iOS SDK](https://www.mapbox.com/ios-sdk/) or [Mapbox macOS SDK](https://github.com/mapbox/mapbox-gl-native/tree/master/platform/macos/), you can create an `MGLPolyline` object using these coordinates to display an overview of the route on an `MGLMapView`.
     
     - parameter coordinates: A pointer to a C array of `CLLocationCoordinate2D` instances. On output, this array contains all the vertices of the overlay.
     
     - precondition: `coordinates` must be large enough to hold `coordinateCount` instances of `CLLocationCoordinate2D`.
     
     - note: This initializer is intended for Objective-C usage. In Swift code, use the `coordinates` property.
     */
    open func getCoordinates(_ coordinates: UnsafeMutablePointer<CLLocationCoordinate2D>) {
        for i in 0..<(self.coordinates?.count ?? 0) {
            coordinates.advanced(by: i).pointee = self.coordinates![i]
        }
    }
    
    /**
     An array of `RouteLeg` objects representing the legs of the route.
     
     The number of legs in this array depends on the number of waypoints. A route with two waypoints (the source and destination) has one leg, a route with three waypoints (the source, an intermediate waypoint, and the destination) has two legs, and so on.
     
     To determine the name of the route, concatenate the names of the route’s legs.
     */
    open let legs: [RouteLeg]
    
    open override var description: String {
        return legs.map { $0.name }.joined(separator: " – ")
    }
    
    // MARK: Getting Additional Route Details
    
    /**
     The route’s distance, measured in meters.
     
     The value of this property accounts for the distance that the user must travel to traverse the path of the route. It is the sum of the `distance` properties of the route’s legs, not the sum of the direct distances between the route’s waypoints. You should not assume that the user would travel along this distance at a fixed speed.
     */
    open let distance: CLLocationDistance
    
    /**
     The route’s expected travel time, measured in seconds.
     
     The value of this property reflects the time it takes to traverse the entire route under ideal conditions. It is the sum of the `expectedTravelTime` properties of the route’s legs. You should not assume that the user would travel along the route at a fixed speed. The actual travel time may vary based on the weather, traffic conditions, road construction, and other variables. If the route makes use of a ferry or train, the actual travel time may additionally be subject to the schedules of those services.
     */
    open let expectedTravelTime: TimeInterval
    
    /**
     `RouteOptions` used to create the directions request.
     
     The route options object’s profileIdentifier property reflects the primary mode of transportation used for the route. Individual steps along the route might use different modes of transportation as necessary.
     */
    open let routeOptions: RouteOptions
}

// MARK: Support for Directions API v4

internal class RouteV4: Route {
    convenience init(json: JSONDictionary, waypoints: [Waypoint], routeOptions: RouteOptions) {
        let leg = RouteLegV4(json: json, source: waypoints.first!, destination: waypoints.last!, profileIdentifier: routeOptions.profileIdentifier)
        let distance = json["distance"] as! Double
        let expectedTravelTime = json["duration"] as! Double
        
        var coordinates: [CLLocationCoordinate2D]?
        switch json["geometry"] {
        case let geometry as JSONDictionary:
            coordinates = CLLocationCoordinate2D.coordinates(geoJSON: geometry)
        case let geometry as String:
            coordinates = decodePolyline(geometry, precision: 1e6)!
        default:
            coordinates = nil
        }
        
        self.init(routeOptions: routeOptions, legs: [leg], distance: distance, expectedTravelTime: expectedTravelTime, coordinates: coordinates)
    }
}
