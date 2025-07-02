import UIKit
import SnapKit

class SectionThreeViewCell: UICollectionViewCell {
    static let identifier = "SectionThreeViewCell"
    
    private let groupFeatureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .users)
        return imageView
    }()
    
    private let groupFeatureLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "단체모임",
            font: .customFontForBody(weight: .w500),
            color: .neutral950
        )
        return label
    }()
    
    private lazy var groupFeatureStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            groupFeatureImageView,
            groupFeatureLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let reserveFeatureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .calendar)
        return imageView
    }()
    
    private let reserveFeatureLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "예약",
            font: .customFontForBody(weight: .w500),
            color: .neutral950
        )
        return label
    }()
    
    private lazy var reserveFeatureStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            reserveFeatureImageView,
            reserveFeatureLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let takeoutFeatureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .bag)
        return imageView
    }()
    
    private let takeoutFeatureLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "포장",
            font: .customFontForBody(weight: .w500),
            color: .neutral950
        )
        return label
    }()
    
    private lazy var takeoutFeatureStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            takeoutFeatureImageView,
            takeoutFeatureLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let parkingFeatureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .car)
        return imageView
    }()
    
    private let parkingFeatureLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "주차",
            font: .customFontForBody(weight: .w500),
            color: .neutral950
        )
        return label
    }()
    
    private lazy var parkingFeatureStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            parkingFeatureImageView,
            parkingFeatureLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var featuresStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            groupFeatureStackView,
            reserveFeatureStackView,
            takeoutFeatureStackView,
            parkingFeatureStackView
        ])
        
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
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
        addSubview(featuresStackView)
    }
    
    private func setConstraints() {
        featuresStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    func update(storeInfo: StoreInfo) {
        
        let hasParking: Bool = {
            guard let parking = storeInfo.parkingOptions else { return false }
            return parking.freeParkingLot == true || parking.paidParkingLot == true || parking.freeStreetParking == true || parking.paidStreetParking == true || parking.valetParking == true || parking.freeGarageParking == true || parking.paidGarageParking == true
        }()
        
        groupFeatureStackView.isHidden = !(storeInfo.goodForGroups ?? false)
        reserveFeatureStackView.isHidden = !(storeInfo.reservable ?? false)
        takeoutFeatureStackView.isHidden = !(storeInfo.takeout ?? false)
        parkingFeatureStackView.isHidden = !hasParking
    }
}
