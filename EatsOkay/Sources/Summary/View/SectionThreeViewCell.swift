import UIKit
import SnapKit

class SectionThreeViewCell: UICollectionViewCell {
    static let identifier = "SectionThreeViewCell"
    
    private let featuresStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private let groupFeatureView = StoreFeatureView()
    private let reserveFeatureView = StoreFeatureView()
    private let takeoutFeatureView = StoreFeatureView()
    private let parkingFeatureView = StoreFeatureView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        
        [
            groupFeatureView,
            reserveFeatureView,
            takeoutFeatureView,
            parkingFeatureView
        ].forEach { featuresStackView.addArrangedSubview($0) }
        
        contentView.addSubview(featuresStackView)
    }
    
    private func setConstraints() {
        featuresStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    func update(storeInfo: StoreInfo) {
        
        groupFeatureView.update(image: UIImage(named: "users"), text: "단체모임")
        reserveFeatureView.update(image: UIImage(named: "calendar"), text: "예약")
        takeoutFeatureView.update(image: UIImage(named: "bag"), text: "포장")
        parkingFeatureView.update(image: UIImage(named: "car"), text: "주차")
        
        let hasParking: Bool = {
            guard let parking = storeInfo.parkingOptions else { return false }
            return parking.freeParkingLot == true || parking.paidParkingLot == true || parking.freeStreetParking == true || parking.paidStreetParking == true || parking.valetParking == true || parking.freeGarageParking == true || parking.paidGarageParking == true
        }()
        
        groupFeatureView.isHidden = !(storeInfo.goodForGroups ?? false)
        reserveFeatureView.isHidden = !(storeInfo.reservable ?? false)
        takeoutFeatureView.isHidden = !(storeInfo.takeout ?? false)
        parkingFeatureView.isHidden = !hasParking
    }
}

private class StoreFeatureView: UIView {
    
    private let featureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let featureLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "",
            font: .customFontForBody(weight: .w500),
            color: .neutral950
        )
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        verticalStackView.addArrangedSubview(featureImageView)
        verticalStackView.addArrangedSubview(featureLabel)
        
        addSubview(verticalStackView)
    }
    
    private func setConstraints() {
        featureImageView.snp.makeConstraints {
            $0.height.width.equalTo(60)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func update(image: UIImage?, text: String) {
        featureImageView.image = image
        featureLabel.attributedText = AttributedStringManager.configureString(
            text: text,
            font: .customFontForBody(weight: .w500),
            color: .neutral950
        )
    }
}
