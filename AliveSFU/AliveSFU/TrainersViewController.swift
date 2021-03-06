//
//  TrainersViewController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-25.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit

class TrainersViewController: UIViewController, WKNavigationDelegate {
    
    private weak var webView: WKWebView?
    private var userContentController: WKUserContentController?
    
    @IBOutlet weak var trainerLabel: UIView!
    @IBOutlet weak var webContainer: UIView!
    private weak var loadingIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor = UIColor.init(red: 238, green: 238, blue: 238).cgColor
        webContainer.layer.borderColor = borderColor
        
        createWebView()
        createLoadingIndicator()
        
        webView?.navigationDelegate = self
        
        loadPage(urlString: "https://www.sfu.ca/students/recreation/active/fitness-centre/training/meetourpt.html", selector: ".main")
    }
    
    private func createLoadingIndicator() {
        let loadingIndicator = UIActivityIndicatorView(frame: webContainer.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        loadingIndicator.color = UIColor(red: 166, green: 25, blue: 46)
        loadingIndicator.stopAnimating()
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        webContainer.addSubview(loadingIndicator)
        
        let centerX = NSLayoutConstraint(item: webContainer, attribute: .centerX, relatedBy: .equal, toItem: loadingIndicator, attribute: .centerX, multiplier: 1, constant: 1)
        let centerY = NSLayoutConstraint(item: webContainer, attribute: .centerY, relatedBy: .equal, toItem: loadingIndicator, attribute: .centerY, multiplier: 1, constant: 1)
        let width = NSLayoutConstraint(item: webContainer, attribute: .width, relatedBy: .equal, toItem: loadingIndicator, attribute: .width, multiplier: 1, constant: 10)
        let height = NSLayoutConstraint(item: webContainer, attribute: .height, relatedBy: .equal, toItem: loadingIndicator, attribute: .height, multiplier: 1, constant: 10)
        
        NSLayoutConstraint.activate([centerX, centerY, width, height])
        
        self.loadingIndicator = loadingIndicator
    }

    private func createWebView() {
        userContentController = WKUserContentController()
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController!
        
        let webView = WKWebView(frame: webContainer.bounds, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        let centerX = NSLayoutConstraint(item: webContainer, attribute: .centerX, relatedBy: .equal, toItem: webView, attribute: .centerX, multiplier: 1, constant: 1)
        let centerY = NSLayoutConstraint(item: webContainer, attribute: .centerY, relatedBy: .equal, toItem: webView, attribute: .centerY, multiplier: 1, constant: 1)
        let width = NSLayoutConstraint(item: webContainer, attribute: .width, relatedBy: .equal, toItem: webView, attribute: .width, multiplier: 1, constant: 10)
        let height = NSLayoutConstraint(item: webContainer, attribute: .height, relatedBy: .equal, toItem: webView, attribute: .height, multiplier: 1, constant: 10)
        
        NSLayoutConstraint.activate([centerX, centerY, width, height])
        
        self.webView = webView
    }
    
    func startLoadUI() {
        loadingIndicator?.startAnimating()
        webView?.alpha = 0.3
    }
    
    func stopLoadUI() {
        loadingIndicator?.stopAnimating()
        webView?.alpha = 1
    }
    
    private func loadPage(urlString: String, selector: String) {
        userContentController!.removeAllUserScripts()
        
        let DOMSelectorScript =
            "var selectedElement = document.querySelector('\(selector)');" +
            "selectedElement.setAttribute('style', 'background-color: #FFFFFF');" +
            "document.body.innerHTML = selectedElement.outerHTML;" +
            "document.body.setAttribute('style', 'background: #FFFFFF');"
        
        let userScript = WKUserScript(source: DOMSelectorScript,
                                      injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
                                      forMainFrameOnly: true)
        
        userContentController!.addUserScript(userScript)
        
        let url = URL(string: urlString)!
        webView!.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopLoadUI()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startLoadUI()
    }
    
}
