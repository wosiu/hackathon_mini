import UIKit
import IndoorwaySdk
import RxSwift

class EventsMapViewController: BasicViewController, IndoorwayMapListener, IndoorwayPositionListener {
    @IBOutlet private weak var eventsMapView: EventsMapView! {
        didSet {
            updateMap()
        }
    }
    
    private let ownerViewModel = OwnerVotesViewModel()
    private let disposeBag = DisposeBag()
    
    private var mapSyncing: Bool = false
    private var positionSyncing: Bool = false
    
    private var currentMapDesc: IndoorwayMapDescription? {
        didSet {
            if currentMapDesc?.mapUuid != oldValue?.buildingUuid {
                updateMap()
            }
        }
    }
    
    let ownerView: OwnerVotesView = {
        $0.alpha = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(OwnerVotesView())
    
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
        setupOwnerView()
        addOwnerView()
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
    
    // MARK: - Owner View
    
    // MARK: - Binding
    
    private func bindView() {
        ownerViewModel.groupEvent.asObservable().subscribe(onNext: { [weak self] (event) in
            guard let event = event else { return }
            self?.ownerView.setup(model: event)
            self?.navigationController?.title = event.name
        }).disposed(by: disposeBag)
    }
    
    // MARK: - UI
    
    private func removeOwnerView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.ownerView.alpha = 0
        }
    }
    
    private func addOwnerView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.ownerView.alpha = 1
        }
    }
    
    private func setupOwnerView() {
        self.view.addSubview(ownerView)
        setupOwnerViewConstrains()
        bindView()
    }
    
    private func setupOwnerViewConstrains() {
        ownerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        ownerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ownerView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        ownerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
}
