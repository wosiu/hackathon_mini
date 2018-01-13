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
    private let participateViewModel = ParticipaterVotesViewModel()
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
    
    private let ownerView: OwnerVotesView = {
        $0.alpha = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(OwnerVotesView())
    
    private let participateView: ParticipaterVotesView = {
        $0.alpha = 0
        $0.nupButton.addTarget(self, action: #selector(voteNo), for: .touchUpInside)
        $0.yupButton.addTarget(self, action: #selector(voteYes), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(ParticipaterVotesView())
    
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
        // setupOwnerView()
        // addOwnerView()
        setupParticipateView()
        addParticipateView()
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
    
    private func bindOwnerView() {
        ownerViewModel.groupEvent.asObservable().subscribe(onNext: { [weak self] (event) in
            guard let event = event else { return }
            self?.ownerView.setup(model: event)
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
        bindOwnerView()
    }
    
    private func setupOwnerViewConstrains() {
        ownerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        ownerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ownerView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        ownerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    // MARK: - Participate View
    
    // MARK: - Setup
    
    private func bindParticipateView() {
        participateViewModel.event.asObservable().subscribe(onNext: { [weak self] (event) in
            guard let event = event else { return }
            self?.participateView.setup(model: event)
        }).disposed(by: disposeBag)
        
    }
    
    // MARK: - Actions
    
    @objc private func voteYes() {
        participateViewModel.vote(postivie: true)
    }
    
    @objc private func voteNo() {
        participateViewModel.vote(postivie: false)
    }
    
    // MARK: - UI
    
    private func removeParticipateView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.participateView.alpha = 0
        }
    }
    
    private func addParticipateView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.participateView.alpha = 1
        }
    }
    
    private func setupParticipateView() {
        self.view.addSubview(participateView)
        setupParticipateViewConstrains()
        bindParticipateView()
    }
    
    private func setupParticipateViewConstrains() {
        participateView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        participateView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        participateView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        participateView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
