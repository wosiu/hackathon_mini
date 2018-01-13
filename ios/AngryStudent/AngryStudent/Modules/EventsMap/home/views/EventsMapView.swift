import UIKit
import IndoorwaySdk


protocol EventsMapViewDelegate: class {
  func eventsMapView(mapDidLoad view: EventsMapView)
  func eventsMapView(failedLoad view: EventsMapView, with error: Error)
}





class EventsMapView: BasicView {
  private let map: IndoorwayMapView = IndoorwayMapView()
  
  
  override func initialize() {
    super.initialize()
    
    addSubview(map)
  }
  
  
  func load(with: IndoorwayMapDescription) {
    

    
    
    
    
  }
  
  

  
  
  
}
