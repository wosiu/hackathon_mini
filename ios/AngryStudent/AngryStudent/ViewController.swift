import UIKit
import IndoorwaySdk

class ViewController: UIViewController {
    
//    let des = IndoorwayMapDescription(buildingUuid: ApiService.defaultInstance.indoorMiNI, mapUuid: ApiService.defaultInstance.indoor2Floor)
//    
//    private var mapView: IndoorwayMapView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        mapView = IndoorwayMapView()
//        self.view.addSubview(mapView)
//        mapView.frame = view.frame
//        configureMap()
//        mapView.delegate = self
//    }
//
//    private func configureMap() {
//        mapView.loadMap(with: des) { [weak self] (completed) in
//            self?.mapView.showsUserLocation = completed
//        }
//    }
    
}

extension ViewController: IndoorwayMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: IndoorwayMapView) {
        print("Załadowało")
    }
    
    func mapViewDidFailLoadingMap(_ mapView: IndoorwayMapView, withError error: Error) {
        print("Nie załadowało ††††")
    }
}

