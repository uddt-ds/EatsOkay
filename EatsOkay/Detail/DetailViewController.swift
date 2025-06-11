//
//  DetailViewController.swift
//  EatsOkay
//
//  Created by 허성필 on 6/9/25.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var testArray = Array(0...4)
    
    private let storeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "5개의 매장"
        label.font = .customFontForSubtitle(weight: .w600)
        return label
    }()
    
    private let sortButton: UIButton = {
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
            button.tintColor = .black
        
        let updateTitle: (String) -> Void = { newTitle in
                var updatedConfig = button.configuration
                let attributedTitle = AttributedString(newTitle, attributes: AttributeContainer([.font: font]))
                updatedConfig?.attributedTitle = attributedTitle
                button.configuration = updatedConfig
            }
        
        let menuItems = [
                UIAction(title: "별점순", handler: { _ in updateTitle("별점순") }),
                UIAction(title: "거리순", handler: { _ in updateTitle("거리순") }),
                UIAction(title: "리뷰순", handler: { _ in updateTitle("리뷰순") }),
                UIAction(title: "가격순", handler: { _ in updateTitle("가격순") })
            ]

        button.menu = UIMenu(title: "", options: .displayInline , children: menuItems)
        button.showsMenuAsPrimaryAction = true
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        return view
    }()
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    

    private func configureUI() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        [storeCountLabel, sortButton, separatorView, tableView].forEach {
            view.addSubview($0)
        }
        
        // 매장 카운드
        storeCountLabel.snp.makeConstraints { make in
            // 기기별 safeAreaHeight를 구하기
            let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
            
            // 구한 safeAreaHeight에 비율 0.389를 곱해서 위치 잡기
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(safeAreaHeight * 0.389)
            make.leading.equalToSuperview().offset(20)
        }
        
        // 정렬 버튼
        sortButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(storeCountLabel)
        }
        
        // 구분선
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(storeCountLabel.snp.bottom).offset(8)
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

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    // 테이블 뷰 섹션 수 지정
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 테이블 뷰 셀들의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    // 테이블 뷰 셀 지정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
    
//        cell.configureView()
        return cell
    }
    
    // 테이블 뷰의 셀의 높이 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    
}
