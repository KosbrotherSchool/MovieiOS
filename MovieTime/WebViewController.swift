//
//  WebViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/11/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate{
    
    var webView: WKWebView
    @IBOutlet weak var progressView: UIProgressView!
    var url:String!
    var web_title:String?
    
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
        
        self.webView.navigationDelegate = self
        
        if let the_title = web_title {
            self.title! = the_title
        }
        
    }
    
    deinit {
        self.webView.stopLoading()
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func viewDidLoad() {
        
        view.insertSubview(webView, belowSubview: progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        let nsUrl = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! )
        let request = NSURLRequest(URL:nsUrl!)
        webView.loadRequest(request)
        
        print(url)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if (keyPath == "estimatedProgress") {
            progressView.hidden = self.webView.estimatedProgress == 1
            progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }

}
