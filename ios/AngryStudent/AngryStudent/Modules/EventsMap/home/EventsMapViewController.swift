import UIKit
import IndoorwaySdk



class EventsMapViewController: BasicViewController, IndoorwayMapListener {
  @IBOutlet private weak var eventsMapView: EventsMapView! {
    didSet {
      if let mapDesc: IndoorwayMapDescription = currentMapDesc {
        eventsMapView?.load(with: mapDesc)
      }
    }
  }
  
  
  private var currentMapDesc: IndoorwayMapDescription? {
    didSet {
      if let mapDesc: IndoorwayMapDescription = currentMapDesc {
        eventsMapView?.load(with: mapDesc)
      }
    }
  }
  
  
  // MARK: IndoorwayMapListener
  func mapChanged(map: IndoorwayMapDescription) {
    currentMapDesc = map
  }
}
