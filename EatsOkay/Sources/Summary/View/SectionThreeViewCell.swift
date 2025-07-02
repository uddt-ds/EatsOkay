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
        
    }
    
    func update(storeInfo: StoreInfo) {
        
        groupFeatureView.update(image: UIImage(named: "users"), text: "단체모임")
        reserveFeatureView.update(image: UIImage(named: "calendar"), text: "예약")
        takeoutFeatureView.update(image: UIImage(named: "bag"), text: "포장")
        parkingFeatureView.update(image: UIImage(named: "car"), text: "주차")
        
        let hasParking = {
            let parking = storeInfo.parkingOptions
            return parking?.freeParkingLot == true || parking?.paidParkingLot == true || parking?.freeStreetParking == true || parking?.paidStreetParking == true || parking?.valetParking == true || parking?.freeGarageParking == true || parking?.paidGarageParking == true
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
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
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
        horizontalStackView.addArrangedSubview(featureImageView)
        horizontalStackView.addArrangedSubview(featureLabel)
        
        addSubview(horizontalStackView)
    }
    
    private func setConstraints() {
        
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
