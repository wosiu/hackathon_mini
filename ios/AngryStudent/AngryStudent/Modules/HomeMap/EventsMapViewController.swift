import UIKit
import IndoorwaySdk


fileprivate let createEventSegue: String = "create_event"


class EventsMapViewController: BasicViewController, IndoorwayMapListener, IndoorwayPositionListener, EventsMapViewDelegate {
  @IBOutlet private weak var eventsMapView: EventsMapView! {
    didSet {
      updateMap()
      eventsMapView.delegate = self
    }
  }
  
  
  private var mapSyncing: Bool = false
  private var positionSyncing: Bool = false
  
  private var currentMapDesc: IndoorwayMapDescription? {
    didSet {
      if currentMapDesc?.mapUuid != oldValue?.buildingUuid {
        updateMap()
      }
      
    }
  }
  
  deinit {
    if mapSyncing {
      IndoorwayLocationSdk.instance().map.onChange.removeListener(listener: self)
    }
    if positionSyncing {
      IndoorwayLocationSdk.instance().position.onChange.removeListener(listener: self)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IndoorwayLocationSdk.instance().position.onChange.addListener(listener: self)
    positionSyncing = true
    IndoorwayLocationSdk.instance().map.onChange.addListener(listener: self)
    mapSyncing = true
    currentMapDesc = IndoorwayLocationSdk.instance().map.latest()
    isLoading = true
    
    navTitle = R.string.main_map_title["MiNI - 2nd floor"]
    view.backgroundColor = Color.white
  }
  
  
  
  private var x: IndoorwayLocation? {
    didSet {
      if oldValue == nil && x != nil {
        eventsMapView!.chuj(x!)
      }
    }
  }
  
  // MARK: EventsMapViewDelegate
  func eventsMapView(mapDidLoad view: EventsMapView) {
    
  }
  func eventsMapView(failedLoad view: EventsMapView, with error: Error) {
    
  }
  
  
  func eventsMapView(didSelect view: EventsMapView, location: IndoorwayLatLon) {
    showOkAlert(title: "\(location.latitude) \(location.longitude)", message: nil)
  }
  
  func eventsMapView(didSelect view: EventsMapView, object: IndoorwayObjectInfo) {
    print(object.objectId)
//    performSegue(withIdentifier: createEventSegue, sender: object)
  }
  
  // MARK: IndoorwayPositionListener
  func positionChanged(position: IndoorwayLocation) {
    
    x = position
  }

  
  

  
  // MARK: IndoorwayMapListener
  func mapChanged(map: IndoorwayMapDescription) {
    
    currentMapDesc = map
  }
  
  // MARK: private
  private func updateMap() {
    if let mapDesc: IndoorwayMapDescription = currentMapDesc {
      
      isLoading = eventsMapView != nil
      eventsMapView?.load(with: mapDesc) {
        [weak self] (succed: Bool) in
        self?.isLoading = false
      }
    }
  }
  
}
