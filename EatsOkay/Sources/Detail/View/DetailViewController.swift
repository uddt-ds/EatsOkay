import UIKit
import GoogleMaps
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import SafariServices

class DetailViewController: UIViewController, GMSMapViewDelegate, View {

    typealias Reactor = DetailReactor
    let reactor: DetailReactor

    // 선언 시에는 초기화 하지 않고 viewDidLoad 시 초기화
    private var mapView: GMSMapView!

    var disposeBag = DisposeBag()
    
    init(reactor: DetailReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var shouldAnimateCamera = false
    
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
        let title = "현 위치에서 검색"
        let button = CustomButton(title: title)
        let text: NSMutableAttributedString = AttributedStringManager.configureString(
            text: title,
            font: .customFontForBody(weight: .w500),
            color: .bgColor
        )
        button.setAttributedTitle(text, for: .normal)
        button.setImage(UIImage(named: "reloadButton"), for: .normal)
        button.setImage(UIImage(named: "reloadButton"), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "currentLocationButton"), for: .normal)
        button.setImage(UIImage(named: "currentLocationButtonPressed"), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let storeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "5개의 매장"
        label.textColor = .customColor(hexCode: .neutral700)
        label.font = .customFontForSubtitle(weight: .w600)
        return label
    }()
        
    lazy var sortButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        let font = UIFont.customFontForSubtitle(weight: .w600)
        let title = "별점순"
        let attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: font]))
        config.attributedTitle = attributedTitle
        
        config.image = UIImage(named: "ChevronDown")
        config.imagePadding = 2     // 텍스트와 이미지 사이 간격
        config.imagePlacement = .trailing // 텍스트 오른쪽에 이미지
        config.contentInsets = .zero
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.tintColor = .customColor(hexCode: .neutral950)
        
        let updateTitle: (String) -> Void = { newTitle in
            var updatedConfig = button.configuration
            let attributedTitle = AttributedString(newTitle, attributes: AttributeContainer([.font: font]))
            updatedConfig?.attributedTitle = attributedTitle
            button.configuration = updatedConfig
        }
        
        let menuItems = [
            UIAction(title: "별점순", handler: { [weak self] _ in
                guard let self else { return }
                self.reactor.action.onNext(.sortButtonTapped(sortType: .rating))
                updateTitle("별점순") }),
            UIAction(title: "거리순", handler: { [weak self] _ in
                guard let self else { return }
                self.reactor.action.onNext(.sortButtonTapped(sortType: .distance))
                updateTitle("거리순") }),
            UIAction(title: "리뷰순", handler: { [weak self] _ in
                guard let self else { return }
                self.reactor.action.onNext(.sortButtonTapped(sortType: .reviewCount))
                updateTitle("리뷰순") })
        ]
        
        button.menu = UIMenu(title: "", options: .displayInline , children: menuItems)
        button.showsMenuAsPrimaryAction = true
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private let separatorView = CustomSeparator(color: .neutral50)
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 145 // delegate 사용 안하고 셀 높이 설정
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .customColor(hexCode: .bgColor)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        configureUI()
        
        bind(reactor: reactor)
        
        self.title = reactor.title
        // 네비게이션 바 타이틀 색상, 폰트 설정
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.customColor(hexCode: .neutral950),
            .font: UIFont.customFontForHeader(weight: .w800)
        ]
        
        navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .customColor(hexCode: .neutral950)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupMapView() {
        // 초기값은 강남구로 설정
        let defaultLat = 37.5171
        let defaultLon = 127.0412
        
        let userLocation = UserDefaultsManager.shared.readLocation()
        let lat = userLocation?.lat ?? defaultLat
        let lon = userLocation?.lon ?? defaultLon
        
        // 초기 줌 레벨을 14.5로 설정
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 14.5)
        
        // GMSMapViewOptions는 지도를 생성할 때 적용할 다양한 설정 값들을 담는 클래스
        let options = GMSMapViewOptions()
        options.camera = camera
        mapView = GMSMapView(options: options)
        mapView.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .customColor(hexCode: .bgColor)
        
        [mapView, storeCountLabel, sortButton, separatorView, tableView].forEach {
            view.addSubview($0)
        }
        
        [
            currentLocationSearchButton,
            currentLocationButton
        ].forEach { mapView.addSubview($0) }
        
        mapView.snp.makeConstraints{
            // 기기별 safeAreaHeight를 구하기
            let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
            
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(safeAreaHeight * 0.3226) // 높이 262
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
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
        
        // 매장 카운드
        storeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            // TODO: 높이 40정도로 설정하기
            make.height.equalTo(view.snp.height).multipliedBy(0.04926)
        }
        
        // 정렬 버튼
        sortButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(storeCountLabel)
        }
        
        // 구분선
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(storeCountLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        // 테이블 뷰
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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
        // viewDidLoad 될 때 Action
        reactor.action.onNext(.viewDidLoad)
        
        // 테이블 뷰 cell 클릭시 Action
        tableView.rx.itemSelected
            .map { indexPath in Reactor.Action.tableViewItemTapped(IndexPath: indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        currentLocationSearchButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.currentLocationSearchButton.isHidden = true
                owner.shouldAnimateCamera = false
            })
            .map { owner, _ in
                let visibleRegion = owner.mapView.projection.visibleRegion()
                let bounds = GMSCoordinateBounds(region: visibleRegion)
                let sw = bounds.southWest
                let ne = bounds.northEast
                
                return Reactor.Action.currentLocationSearchButtonTapped(
                    sw: (lat: sw.latitude, lon: sw.longitude),
                    ne: (lat: ne.latitude, lon: ne.longitude)
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        currentLocationButton.rx.tap
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.shouldAnimateCamera = true
            })
            .map {_ in Reactor.Action.currentLocationButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DetailReactor) {
        reactor.state
            .map { $0.storeInfo.first?.items ?? [] }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, stores in
                guard let mapView = owner.mapView else { return }
                // 캐시나 재사용된 경우 마커가 겹칠 수 있기 때문에 초기화
                mapView.clear()
                for store in stores {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
                    marker.title = store.displayName
                    marker.icon = UIImage(named: "customMarker")
                    marker.map = mapView
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.shouldPop }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$showLocationAlert)
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, void in
                guard void != nil else { return }
                let locationAlert = CustomLocationAlert()
                locationAlert.modalPresentationStyle = .overFullScreen
                locationAlert.modalTransitionStyle = .crossDissolve
                owner.present(locationAlert, animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            // currentLatitude, currentLongitute 값이 둘 다 존재할 경우 tuple로 return
            .compactMap { state -> (Double, Double)? in
                guard let lat = state.currentLatitude,
                      let lon = state.currentLongitude else { return nil }
                return (lat, lon)
            }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, coordinate in
                guard owner.shouldAnimateCamera else { return }
                // 줌 레벨 14.5로 설정
                let camera = GMSCameraPosition.camera(withLatitude: coordinate.0, longitude: coordinate.1, zoom: 14.5)
                owner.mapView.animate(to: camera)
                owner.mapView.isMyLocationEnabled = true
            })
            .disposed(by: disposeBag)
        
        // TableView rxDataSource
        let dataSource = RxTableViewSectionedAnimatedDataSource<StoreSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
                cell.configureView(with: item)
                return cell
            }
        )
        
        // 테이블 뷰 State 바인딩
        reactor.state
            .map { $0.storeInfo }
            .asDriver(onErrorDriveWith: .empty())
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // tableView cell 클릭 시 WebView 띄우기
        reactor.state
            .map { $0.shouldPresentWebView }
            .distinctUntilChanged()
            .filter { $0 }
            .withLatestFrom(reactor.state.map { $0.webViewUrl })
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] urlString in
                guard let url = URL(string: urlString) else { return }
                let safariVC = SFSafariViewController(url: url)
                safariVC.modalPresentationStyle = .popover
                safariVC.delegate = self // 모달 닫기 delegate
                safariVC.presentationController?.delegate = self // 모달 드래그 delegate
                self?.present(safariVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        // 매장 개수 Label에 StoreInfo 매장 개수 바인딩
        reactor.state
            .map { $0.storeInfo.flatMap { $0.items }.count }
            .distinctUntilChanged() // 같은 값은 출력하지 않음 - 매장 수가 변경될 때만 표시
            .map { "\($0)개의 매장"}
            .asDriver(onErrorJustReturn: "0개의 매장") // 에러시 출력
            .drive(storeCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// 지도 이동이 끝났을 때 호출
extension DetailViewController {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        currentLocationSearchButton.isHidden = false
    }
}

// 모달을 완료 버튼으로 dismiss 했을 때 체크
extension DetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        reactor.action.onNext(.webViewDidDismiss)
    }
}

// 모달을 드래그로 dismiss 했을 때 체크
extension DetailViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        reactor.action.onNext(.webViewDidDismiss)
    }
}
