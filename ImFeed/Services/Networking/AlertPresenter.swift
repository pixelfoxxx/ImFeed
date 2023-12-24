//
//  AlertPresenter.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 24/12/2023.
//

import UIKit

struct AlertPresenter {
    static func presentAlert(on viewController: UIViewController, title: String, message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        viewController.present(alert, animated: true)
    }
}
