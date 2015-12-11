//
//  CreditViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/28/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    var url = ["http://creditcardmovie.blogspot.tw/2015/08/2015.html","http://creditcardmovie.blogspot.tw/2015/08/2015_31.html"]
    
    @IBAction func switchSegment(sender: AnyObject) {
        
        switch segmentControl.selectedSegmentIndex{
        case 0:
            let requestObj = NSURLRequest(URL: NSURL(string: self.url[0])! );
            webView.loadRequest(requestObj);
        case 1:
            let requestObj = NSURLRequest(URL: NSURL(string: self.url[1])! );
            webView.loadRequest(requestObj);
        default:
            let requestObj = NSURLRequest(URL: NSURL(string: self.url[0])! );
            webView.loadRequest(requestObj);
        }
        
    }
    
    
    override func viewDidLoad() {
        webView.delegate = self
        let requestObj = NSURLRequest(URL: NSURL(string: self.url[0])! );
        webView.loadRequest(requestObj);
    }
    
    func webViewDidStartLoad(webView: UIWebView){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
}