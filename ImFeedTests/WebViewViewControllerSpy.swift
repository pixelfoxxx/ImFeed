//
//  WebViewViewControllerSpy.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 03/02/2024.
//

import Foundation

final class WebViewViewControllerSpy: WebViewProtocol {
    var presenter: ImFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    var lastProgressValue: Float?
    
    func loadRequest(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func updateProgress(progress: Float) {
        lastProgressValue = progress
    }
}
