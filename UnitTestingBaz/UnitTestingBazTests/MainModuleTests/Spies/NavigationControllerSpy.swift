//
//  NavigationControllerSpy.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import UIKit
 
class SpyNavigationController: UINavigationController {
    
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: true)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        pushedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: true, completion: nil)
    }
}


class TableViewSpy: UITableView {
    var registeredCell: AnyClass?
    
    override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        registeredCell = cellClass
        super.register(cellClass, forCellReuseIdentifier: identifier)
    }
}
