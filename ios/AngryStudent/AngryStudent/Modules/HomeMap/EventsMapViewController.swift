import UIKit
import IndoorwaySdk



class EventsMapViewController: BasicViewController, IndoorwayMapListener, IndoorwayPositionListener {
  @IBOutlet private weak var eventsMapView: EventsMapView! {
    didSet {
      updateMap()
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
  }
  
  
  private var x: IndoorwayLocation? {
    didSet {
      if oldValue == nil && x != nil {
        eventsMapView!.chuj(x!)
      }
    }
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
