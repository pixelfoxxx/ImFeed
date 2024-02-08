//
//  NavigationManager.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 05/02/2024.
//

import UIKit

public class NavigationManager {
    
    public static let shared = NavigationManager()
    
    private init() {}
    
    public func navigateToInitialScreen() {
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.switchToInitialViewController()
            }
        }
    }
}
