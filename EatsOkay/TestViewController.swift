//
//  TestViewController.swift
//  EatsOkay
//
//  Created by 김기태 on 6/12/25.
//

import RxSwift
import UIKit

class TestViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.shared
            .fetchPlacesWithCircle(textQuery: "카페", centerLat: 37.5665, centerLon: 126.9780)  // 서울시청 근처
            .subscribe(onSuccess: { places in
                print("원형 검색 결과 개수: \(places.count)")
                for place in places {
                    print("\(place.displayName), \(place.rating),\(place.userRatingCount),\(place.primaryTypeDisplayName?.text),\(place.formattedAddress),\(place.currentOpeningHours?.openNow),\(place.googleMapsURI),\(place.currentOpeningHours?.periods)")
                }
            }, onFailure: { error in
                print("에러 발생: \(error)")
            })
            .disposed(by: disposeBag)
        
        testRectangleAPI()
        loadImage(mediaName: "places/ChIJ1fcl6CujfDURIfH0uohi-dM/photos/AXQCQNQSK-3MJBkqyrIvvNUGx8iyM2u8ayuEjBUSeMGwNJqiBOLBdt5F0-71bt8JxdmxQ_DzDv5KKE4NUkiuaTwo4Rc96zpGJ3KqPjpIpDNakpPcGgHJsmjwI7W8nNkZXuwOWHLwL7bDdUgIzzEsyuVZpi44i-Lk3VUBnlYiH3407Q7o7O70CEo3WqVir4kfr3Bdlb-e1LfxULVSOotV6XDEWcPVgKgrgLKRNGQdbqs75pTfy8LpSnxSCtzDtrjxQBE40q0Hk4xPgKZTr3WbbeBbdfmh9ZPSE-bYWUumnUDvh0iwsYGH3frBbx9Hy_u3WCI8Pp76CHOoPejbYdhCZjX0zhCNevPW3q7hhvB5RHkkUr-ssb0FsnWy_Si0tfARH7mhBpMXVsSJ739NuVW9ggDvUkIspE4h2bLLeuYHn228Tt5ySQ")
        
    }
    
    func testRectangleAPI() {
        let centerLat: Double = 37.5563
                let centerLon: Double = 126.9723
                let offset: Double = 0.005   // 약 500m 거리
                
                // 저좌표(남서쪽), 고좌표(북동쪽)
                let lowLat = centerLat - offset
                let lowLon = centerLon - offset
                let highLat = centerLat + offset
                let highLon = centerLon + offset
                
                let textQuery = "카페"  // 검색어 예시
                
                NetworkManager.shared
                    .fetchPlacesWithRectangle(
                        textQuery: textQuery,
                        lowLat: lowLat,
                        lowLon: lowLon,
                        highLat: highLat,
                        highLon: highLon
                    )
                    .subscribe(onSuccess: { places in
                        print("사각형 검색된 장소 수: \(places.count)")
                        for place in places {
                            print("\(place.formattedAddress)")
                        }
                    }, onFailure: { error in
                        print("에러 발생: \(error.localizedDescription)")
                    })
                    .disposed(by: disposeBag)
    }
    
    func loadImage(mediaName: String) {
        NetworkManager.shared
            .fetchImage(mediaName: mediaName)
            .subscribe(onSuccess: { data in
                if let image = UIImage(data: data) {
                    print("이미지 로드 성공: \(image)")
                }
            }, onFailure: { error in
                print("이미지 로드 실패: \(error)")
                
            })
            .disposed(by: disposeBag)
    }
}
