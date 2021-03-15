//
//  BaseViewController.swift
//  PangleAd
//
//  Created by my on 2021/3/15.
//

import UIKit

internal class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .init(rawValue: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(customPopBack))
    }
    
    @objc func customPopBack() {
        navigationController?.popViewController(animated: true)
    }
}
