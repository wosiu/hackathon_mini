import UIKit
import IndoorwaySdk


protocol EventsMapViewDelegate: class {
  func eventsMapView(mapDidLoad view: EventsMapView)
  func eventsMapView(failedLoad view: EventsMapView, with error: Error)
}

enum ExampleMapViewIdentifiers: String {
  case exampleAnnotation = "example.annotation.view.identifier.example"
  case userLocationAnnotation = "example.annotation.view.identifier.userlocation"
}

class ExampleAnnotation: NSObject, IndoorwayAnnotation {
  var coordinate: IndoorwayLatLon
  var title: String?
  var subtitle: String?
  
  init(coordinate: IndoorwayLatLon) {
    title = "ehhh"
    
    self.coordinate = coordinate
    super.init()
  }
}



class EventsMapView: BasicView, IndoorwayMapViewDelegate {
  private let map: IndoorwayMapView = IndoorwayMapView()
  private let mapNotLoadedView: UIView = UIView()
  
  
  func chuj(_ x: IndoorwayLocation) {
    
    
//    print("CHUJ!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    
    
  }
  
  override func initialize() {
    super.initialize()
    
    backgroundColor = Color.white
    
    addSubview(map)
    addSubview(mapNotLoadedView)
    
    mapNotLoadedView.backgroundColor = backgroundColor
    
    map.delegate = self
  }
  
  override var backgroundColor: UIColor? {
    didSet {
      mapNotLoadedView.backgroundColor = backgroundColor
    }
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    map.frame = bounds
    mapNotLoadedView.frame = map.frame
    
    
    
  }
  
  func load(with desc: IndoorwayMapDescription, completion: ((Bool) -> ())? = nil) {
    
    map.loadMap(with: desc) {
      [weak self] (succeed: Bool) in
      completion?(succeed)
      self?.map.showsUserLocation = succeed
      self?.mapNotLoadedView.isHidden = succeed
      
      
    }
    
  }
  
  // MARK:: IndoorwayMapViewDelegate
  /// Method called when map did finish loading
  ///
  /// - parameter mapView: The map view that did finish loading
  @objc func mapViewDidFinishLoadingMap(_ mapView: IndoorwayMapView) {
    let annotation = ExampleAnnotation(
      coordinate: IndoorwayLatLon(latitude: 52.2219467163086, longitude: 21.0067615509033)
    )
    mapView.addAnnotation(annotation)
  }
  
  /// Method called when map did fail loading map
  ///
  /// - parameter mapView: The map view that did fail loading map
  /// - parameter error:   Error that occurred
  @objc func mapViewDidFailLoadingMap(_ mapView: IndoorwayMapView, withError error: Error) {
    
  }
  
  /// Method called when user did tap location
  ///
  /// - parameter mapView:  The map view that received tap
  /// - parameter location: The location where tap was received
  @objc func mapView(_ mapView: IndoorwayMapView, didTapLocation location: IndoorwayLatLon) {
    print("didTapLocation")
  }
  
  /// Method tells the delegate that the location of the user was updated.
  ///
  /// - parameter mapView:      The map view which determines user location
  /// - parameter userLocation: The updated user location
  @objc func mapView(_ mapView: IndoorwayMapView, didUpdate userLocation: IndoorwayUserLocation) {
//    userLocation.
//    print("didUpdate")
  }
  
  /// Method tells the delegate that an attempt to locate the user’s position failed.
  ///
  /// - parameter mapView: The map view which determines user location
  /// - parameter error:   The error containing a reason that determining user location failed
  @objc func mapView(_ mapView: IndoorwayMapView, didFailToLocateUserWithError error: Error) {
    print("didFailToLocateUserWithError")
  }
  
  /// Method determines that map view should select Indoorway object
  ///
  /// - parameter mapView:          The map view that should or not select object
  /// - parameter indoorObjectInfo: The object that should or not be selected
  ///
  /// - returns: returns true if object should be selected
  @objc func mapView(_ mapView: IndoorwayMapView, shouldSelectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) -> Bool {
    print("should select")
    return true
  }
  
  /// Method called when Indoorway object did select
  ///
  /// - parameter mapView:          The map view that contains selected Indoorway object
  /// - parameter indoorObjectInfo: The selected Indoorway object
  @objc func mapView(_ mapView: IndoorwayMapView, didSelectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) {
    print(indoorObjectInfo.objectId)
    
    
    print("didSelectIndoorObject")
    mapView.deselectObject()
  }
  
  /// Method called when Indoorway object did deselect
  ///
  /// - parameter mapView:          The map view that contains deselected Indoorway object
  /// - parameter indoorObjectInfo: The deselected Indoorway object
  @objc func mapView(_ mapView: IndoorwayMapView, didDeselectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) {
    let x = mapView.indoorObjects[0]
    
    print("didDeselectIndoorObject")
  }
  
  /// Method returns the view associated with the specified annotation object
  ///
  ///  Discussion:
  ///    Rather than creating new view each time the method is called, it should call `dequeueReusableAnnotationViewWithIdentifier(_ identifier:)` on the `IndoorwayMapView` instance to obtain dequeued view.
  ///    If it doesn't exist, it should create a new one. After both of ways view should be configured to reflect the annotation properties before returning.
  ///    If the object in the annotation parameter is an instance of the IndoorwayUserLocation class, you can provide a custom view to display the user’s location.
  ///    To display the user’s location using the standard system view, return nil.
  ///    If you do not implement this method, or if you return nil from your implementation for annotations other than the user location annotation, the map view uses a standard circle annotation view.
  ///
  /// - parameter mapView:    The map view that asked the annotation view
  /// - parameter annotation: The object that represents the annotation that is about to be displayed. In addition to your custom annotations, this object could be an IndoorwayUserLocation object representing the user’s current location.
  ///
  /// - returns: The annotation view to display for the specified annotation or nil if you want to display a standard annotation view
  @objc func mapView(_ mapView: IndoorwayMapView, viewForAnnotation annotation: IndoorwayAnnotation) -> IndoorwayAnnotationView? {
    var view: IndoorwayAnnotationView? = nil

    // Example annotation
    if let annotation = annotation as? ExampleAnnotation {
      // Reused annotation view

      if let reusedView = mapView.dequeueReusableAnnotationView(withIdentifier: ExampleMapViewIdentifiers.userLocationAnnotation.rawValue) {
        reusedView.annotation = annotation
        view = reusedView
      }
        // New annotation view
      else {
        let newView = IndoorwayAnnotationView(annotation: annotation, reuseIdentifier: ExampleMapViewIdentifiers.userLocationAnnotation.rawValue)
        newView.annotation = annotation
        newView.bounds.size = CGSize(width:30, height: 30)
        newView.backgroundColor = .blue
        newView.layer.cornerRadius = newView.bounds.height/2.0
        view = newView
      }
    }

      // User location view

    return view
    return nil
//    return nil
  }
  
  /// Method called when user did select annotation view
  ///
  /// - parameter mapView: The map view that contains annotation view
  /// - parameter view:    The selected annotation view
  @objc func mapView(_ mapView: IndoorwayMapView, didSelectAnnotationView view: IndoorwayAnnotationView) {
    print("didSelectAnnotationView")
  }
  
  /// Method called when user did deselect annotation view
  ///
  /// - parameter mapView: The map view that contains annotation view
  /// - parameter view:    The deselected annotation view
  @objc func mapView(_ mapView: IndoorwayMapView, didDeselectAnnotationView view: IndoorwayAnnotationView) {
    print("didDeselectAnnotationView")
  }

  
}


