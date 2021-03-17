//
//  CategoryListController.swift
//  PangleAd
//
//  Created by my on 2021/3/15.
//

import UIKit
import GeSwift
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit

internal final class CategoryListController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rowHeight = 50
        $0.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        $0.separatorColor = UIColor.ge.color(with: "efefef")
        $0.tableFooterView = UIView()
        $0.ge.register(reusableCell: CategoryListCell.self)
        self.view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pangle AD"
        
        navigationItem.leftBarButtonItem = nil
        
        let dataSource = RxTableViewSectionedReloadDataSource<ADCategory>(configureCell: { dataSource, tableView, indexPath, item in
            let cell: CategoryListCell = tableView.ge.dequeueReusableCell()
            cell.titleLabel.text = item.rawValue
            return cell
        }, titleForHeaderInSection: { dataSource, section in
            return dataSource[section].name
        })
        
        Observable.just(ADCategory.defaultModelList).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        Observable.combineLatest(tableView.rx.itemSelected.map({ dataSource[$0.section] }), tableView.rx.modelSelected(ADList.self))
            .subscribe(onNext: handleSelectItem)
            .disposed(by: disposeBag)
    }
    
    func handleSelectItem(_ item: (adCategory: ADCategory, item: ADList)) {
        let _category: AdLoadController.Category
        switch item.adCategory {
        case .default:
            _category = .default
        case .express:
            _category = .express
        }
        let controller = AdLoadController(ad: item.item, category: _category)
        controller.title = String(format: "%@-%@", item.adCategory.name, item.item.rawValue)
        navigationController?.pushViewController(controller, animated: true)
    }
}
