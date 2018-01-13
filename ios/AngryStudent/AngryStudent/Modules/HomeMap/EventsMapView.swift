import UIKit
import IndoorwaySdk


protocol EventsMapViewDelegate: class {
  func eventsMapView(mapDidLoad view: EventsMapView)
  func eventsMapView(failedLoad view: EventsMapView, with error: Error)
  
  
  func eventsMapView(didSelect view: EventsMapView, location: IndoorwayLatLon)
  func eventsMapView(didSelect view: EventsMapView, object: IndoorwayObjectInfo)
}

enum ExampleMapViewIdentifiers: String {
  case exampleAnnotation = "example.annotation.view.identifier.example"
  case userLocationAnnotation = "example.annotation.view.identifier.userlocation"
}

class ExampleAnnotation: NSObject, IndoorwayAnnotation {
  var coordinate: IndoorwayLatLon
  var title: String?
  var subtitle: String?
  
  
  static var room211: ExampleAnnotation = ExampleAnnotation(
    coordinate: IndoorwayLatLon(
      latitude: 52.2219589680484, // 52.2219467163086,
      longitude: 21.0067591639562 // 21.0067615509033
    )
  )
  
  
  static var room212: ExampleAnnotation = ExampleAnnotation(
    coordinate: IndoorwayLatLon(
      latitude: 52.2220465705931, // 52.2220465705931 21.0067572030207
      longitude: 21.0067572030207 // 21.0067615509033
    )
  )
  
  static var room213: ExampleAnnotation = ExampleAnnotation(
    coordinate: IndoorwayLatLon(
      latitude: 52.2221348895405, // 52.2221348895405 21.0067570552191
      longitude: 21.0067570552191 // 21.0067615509033
    )
  )
  
  
  static var room214: ExampleAnnotation = ExampleAnnotation(
    coordinate: IndoorwayLatLon(
      latitude: 52.222219869846, // 52.222219869846 21.0067581477856
      longitude: 21.0067581477856 // 21.0067615509033
    )
  )
  
  static var room216: ExampleAnnotation = ExampleAnnotation(
    coordinate: IndoorwayLatLon(
      latitude: 52.2223362891784, // 52.2223362891784 21.0067557652251
      longitude: 21.0067557652251 // 21.0067615509033
    )
  )
  
  static var room103: ExampleAnnotation = ExampleAnnotation(
    coordinate: IndoorwayLatLon(
      latitude: 52.2222260223577, // 52.2223362891784 21.0067557652251
      longitude: 21.0067850431649 // 21.0067615509033
    )
  )
  
  
  static var room107: ExampleAnnotation = ExampleAnnotation(
    coordinate: IndoorwayLatLon(
      latitude: 52.22214602921, // 52.2223362891784 21.0067557652251
      longitude: 21.0071133361957 // 21.0067615509033
    )
  )
  
  init(coordinate: IndoorwayLatLon) {
    title = "ehhh"
    
    
    self.coordinate = coordinate
    super.init()
  }
}





class EventIcon: IndoorwayAnnotationView {
  
  private let imgView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "Book").withRenderingMode(UIImageRenderingMode.alwaysTemplate))
  
  override init(annotation: IndoorwayAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    initialize()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  
  
  private func initialize() {
    
    backgroundColor = Color.blueLight
    imgView.tintColor = Color.blue
    addSubview(imgView)
    
    imgView.contentMode = UIViewContentMode.scaleAspectFit
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height/2.0
   
    
    let imgS: CGSize = CGSize(width: CGFloat(17.0), height: CGFloat(17.0))
    imgView.bounds.size = imgS
    imgView.center = CGPoint(x: bounds.midX, y: bounds.midY)
  }
  
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: CGFloat(35.0), height: CGFloat(35.0))
  }
}



extension IndoorwayMapView {
  var scrollView: UIScrollView {
    for view: UIView in subviews {
      if let sv: UIScrollView = view as? UIScrollView {
        return sv
      }
    }
    fatalError("DUPA")
  }
}

class EventsMapView: BasicView, IndoorwayMapViewDelegate {
  private let map: IndoorwayMapView = IndoorwayMapView()
  private let mapNotLoadedView: UIView = UIView()
  
  weak var delegate: EventsMapViewDelegate?
  
  
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
    
    print(map.scrollView.maximumZoomScale)
    
    
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
    
//    mapView.addAnnotation(ExampleAnnotation.room211)
//    mapView.addAnnotation(ExampleAnnotation.room212)
//    mapView.addAnnotation(ExampleAnnotation.room213)
//    mapView.addAnnotation(ExampleAnnotation.room214)
//    mapView.addAnnotation(ExampleAnnotation.room216)
    
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
    print("\(location.longitude), \(location.latitude)")
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
  
  
  @objc func mapView(_ mapView: IndoorwayMapView, shouldSelectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) -> Bool {
    return false
  }
  
  
  @objc func mapView(_ mapView: IndoorwayMapView, didSelectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) {
    mapView.deselectObject()
  }
  

  
  private var annotationId: Int = 0
  @objc func mapView(_ mapView: IndoorwayMapView, viewForAnnotation annotation: IndoorwayAnnotation) -> IndoorwayAnnotationView? {
    var view: IndoorwayAnnotationView? = nil

    
  
    // Example annotation
    if let annotation = annotation as? ExampleAnnotation {
      // Reused annotation view
      
      annotationId = annotationId + 1
      if let reusedView = mapView.dequeueReusableAnnotationView(withIdentifier: "\(annotationId)") {
        reusedView.annotation = annotation
        view = reusedView
      }
        // New annotation view
      else {
        let newView = EventIcon(annotation: annotation, reuseIdentifier: ExampleMapViewIdentifiers.userLocationAnnotation.rawValue)
        newView.annotation = annotation
        newView.bounds.size = newView.intrinsicContentSize
        
        
        view = newView
      }
    } else {
      print(annotation.title)
    }

      // User location view

    return view
    return nil
//    return nil
  }
  
  
  
 

  
}


