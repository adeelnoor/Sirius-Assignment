//
//  UIViewController.swift
//  Assignment
//
//  Created by Adeel-dev on 3/3/22.
//

import UIKit

extension UIViewController {
    @discardableResult
    func alert(title: String? = nil, message: String? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        return alert
    }
}
