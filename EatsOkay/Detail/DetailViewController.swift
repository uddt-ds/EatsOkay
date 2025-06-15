
import UIKit
import GoogleMaps
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController, GMSMapViewDelegate, View {

    typealias Reactor = DetailReactor

    // 선언 시에는 초기화 하지 않고 viewDidLoad 시 초기화
    private var mapView: GMSMapView!

    var disposeBag = DisposeBag()
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "chevronLeft"),
            style: .plain,
            target: nil,
            action: nil
            )
        return button
    }()
    
    private let currentLocationSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("현 위치에서 검색", for: .normal)
        button.setTitleColor(.customColor(hexCode: .bgColor), for: .normal)
        button.titleLabel?.font = .customFontForBody(weight: .w400)
        button.backgroundColor = .customColor(hexCode: .primary400)
        button.setImage(UIImage(named: "reloadButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "currentLocationButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = DetailReactor()
        if let reactor = self.reactor {
            bind(reactor: reactor)
            reactor.action.onNext(.viewDidLoad)
        }
        view.backgroundColor = .customColor(hexCode: .bgColor)
        setupMapView()
        constraintsMapView()
        
        // 임시 타이틀 → 추후 UI 변경 및 키워드 기반으로 바인딩 예정
        self.title = "퇴근 후, 혼술 타임"
        
        navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .customColor(hexCode: .neutral950)
    }
    
    private func setupMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 37.5171, longitude: 127.0412, zoom: 12)
        
        // GMSMapViewOptions는 지도를 생성할 때 적용할 다양한 설정 값들을 담는 클래스
        let options = GMSMapViewOptions()
        options.camera = camera
        mapView = GMSMapView(options: options)
        
        mapView.delegate = self
    }
    
    // 제약조건 설정
    private func constraintsMapView() {
        [
            mapView
        ].forEach { view.addSubview($0) }
        
        [
            currentLocationSearchButton,
            currentLocationButton
        ].forEach { mapView.addSubview($0) }
        
        mapView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(262)
        }
        
        currentLocationSearchButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview().inset(120)
            $0.height.equalTo(32)
        }
        
        currentLocationButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(32)
        }
    }
}

extension DetailViewController {
    // reactor와 view 연결
    func bind(reactor: DetailReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DetailReactor) {
        backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        currentLocationButton.rx.tap
            .map { Reactor.Action.currentLocationButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DetailReactor) {
        reactor.state
            .map { $0.storeInfo.first?.items ?? [] }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, stores in
                guard let mapView = owner.mapView else { return }
                // 캐시나 재사용된 경우 마커가 겹칠 수 있기 때문에 초기화
                mapView.clear()
                for store in stores {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
                    marker.title = store.displayName
                    marker.map = mapView
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.shouldPop }
            .distinctUntilChanged()
            .filter { $0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            // currentLatitude, currentLongitute 값이 둘 다 존재할 경우 tuble로 return
            .compactMap { state -> (Double, Double)? in
                guard let lat = state.currentLatitude,
                      let lon = state.currentLongitute else { return nil }
                return (lat, lon)
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, coordinate in
                let camera = GMSCameraPosition.camera(withLatitude: coordinate.0, longitude: coordinate.1, zoom: 15)
                owner.mapView.animate(to: camera)
            })
            .disposed(by: disposeBag)
    }
}
