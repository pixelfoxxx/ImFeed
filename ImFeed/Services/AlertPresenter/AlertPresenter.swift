//
//  AlertPresenter.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 25/12/2023.
//

import UIKit

struct AlertPresenter {
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}
