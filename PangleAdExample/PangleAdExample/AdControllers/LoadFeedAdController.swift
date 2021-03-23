//
//  LoadFeedAdController.swift
//  PangleAdExample
//
//  Created by my on 2021/3/15.
//

import UIKit
import GeSwift
import BUAdSDK
import RxSwift
import RxCocoa
import RxDataSources

protocol FeedListItemCompatible {}

extension Int: FeedListItemCompatible {}

extension BUNativeExpressAdView: FeedListItemCompatible {}

internal final class NormalTitleCell: UITableViewCell, Reusable {
    lazy var titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.textColor = UIColor.ge.color(with: "333333")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY).offset(0)
            make.left.equalTo(15)
        }
        return $0
    }(UILabel())
}

internal final class FeedAdCell: UITableViewCell, Reusable {
    lazy var containerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return $0
    }(UIView())
}

internal final class LoadFeedAdController: BaseViewController {
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rowHeight = 44
        $0.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        $0.separatorColor = UIColor.ge.color(with: "EFEFEF")
        $0.tableFooterView = UIView()
        $0.ge.register(reusableCell: NormalTitleCell.self)
        $0.ge.register(reusableCell: FeedAdCell.self)
        self.view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    let adViews: [BUNativeExpressAdView]
    init(_ adViews: [BUNativeExpressAdView]) {
        self.adViews = adViews
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var list: [FeedListItemCompatible] = []
    
    let dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, FeedListItemCompatible>> = RxTableViewSectionedReloadDataSource(configureCell: { dataSource, tableView, indexPath, item in
        if let item = item as? BUNativeExpressAdView {
            let cell: FeedAdCell = tableView.ge.dequeueReusableCell()
            cell.containerView.addSubview(item)
            return cell
        } else {
            let cell: NormalTitleCell = tableView.ge.dequeueReusableCell()
            cell.titleLabel.text = String(format: "%d", indexPath.row)
            return cell
        }
    })

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let totalCount = 50
        list = Array(repeating: totalCount, count: 0)
        if adViews.count < totalCount {
            for index in 0 ..< adViews.count {
                let _index = Int(arc4random() % UInt32(totalCount))
                list.insert(adViews[index], at: _index)
            }
        } else {
            list = adViews
        }
        
        Observable.just([SectionModel(model: "", items: list)])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension LoadFeedAdController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataSource[indexPath]
        if item is BUNativeExpressAdView {
            return 150
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}
