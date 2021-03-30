//
//  CategoryListCell.swift
//  PangleAd
//
//  Created by my on 2021/3/15.
//

import UIKit
import GeSwift

internal final class CategoryListCell: UITableViewCell, Reusable {
    internal lazy var titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.textColor = UIColor.ge.color(with: "333333", transparency: 1)
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY).offset(0)
            make.left.equalTo(15)
        }
        return $0
    }(UILabel())
}
