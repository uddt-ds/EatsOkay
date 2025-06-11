
import UIKit
import GoogleMaps
import SnapKit

class DetailViewController: UIViewController, GMSMapViewDelegate {
    
    // 선언 시에는 초기화 하지 않고 viewDidLoad 시 초기화
    private var mapView: GMSMapView!
    
    private let currentLocationSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("현 위치에서 검색", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 13)
        button.backgroundColor = .systemPink
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
        view.backgroundColor = .white
        setupMapView()
        constraintsMapView()
        
        // title 우선 하드 코딩
        self.title = "퇴근 후, 혼술 타임"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    private func setupMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15)
        
        // GMSMapViewOptions는 지도를 생성할 때 적용할 다양한 설정 값들을 담는 클래스
        let options = GMSMapViewOptions()
        options.camera = camera
        mapView = GMSMapView(options: options)
        
        mapView.delegate = self
    }
    
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
            $0.height.equalTo(250)
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
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
