//
//  TalkDetailCell.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/29/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import DOFavoriteButton
import WebKit

class TalkDetailCell: UICollectionViewCell,WKNavigationDelegate{
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var pub_date: UILabel!
    @IBOutlet weak var likeButton: DOFavoriteButton!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
    var webView: WKWebView!
    var progress:UIProgressView!
    var expandButton:UIButton!
    var toolBar:UIToolbar!
    var self_frame:CGRect!
    
    deinit{
        if let theWebView = self.webView{
            theWebView.stopLoading()
            theWebView.removeObserver(self, forKeyPath: "estimatedProgress")
        }
    }
    
    func addWebView(url:String, cell_width:CGFloat, progress_y:CGFloat){
        
        self_frame = self.frame
        if progress == nil{
            progress = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
            progress.frame = CGRectMake(8, progress_y, cell_width-16, 2)
            progress.autoresizesSubviews = true
            self.addSubview(progress!)
        }
        
        
        if expandButton == nil {
            expandButton = UIButton(type: UIButtonType.System) as UIButton
            expandButton.frame = CGRectMake(16, progress.frame.origin.y+210, cell_width-32, 40)
            expandButton.backgroundColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
            expandButton.tintColor = UIColor.whiteColor()
            expandButton.setTitle("展開", forState: UIControlState.Normal)
            expandButton.addTarget(self, action: "expandAction:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(expandButton)
        }
        
        if webView == nil {
            /* Create our preferences on how the web page should be loaded */
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = false
            
            /* Create a configuration for our preferences */
            let configuration = WKWebViewConfiguration()
            configuration.preferences = preferences
            
            /* Now instantiate the web view */
            webView = WKWebView(frame:  CGRectMake(8, progress.frame.origin.y+2, cell_width-16, 200), configuration: configuration)
            webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
            let url = NSURL(string: url)
            let urlRequest = NSURLRequest(URL: url!)
            webView.loadRequest(urlRequest)
            webView.navigationDelegate = self
            
            self.addSubview(webView)
        }
    }
    
    func expandAction(sender:UIButton!)
    {
        
        let collectionView = superview as! UICollectionView
        for cell in collectionView.visibleCells(){
            let cell_index = collectionView.indexPathForCell(cell)!
            if (cell_index.row != 0){
                cell.hidden = true
            }
        }
        // status bar 20 pts, navigation 44 pts, tab bar 49 pts
        self.frame = CGRectMake(0,  0, superview!.frame.width, superview!.frame.height - 20 - 44 - 49)
        
        toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1) // button color

        let doneButton = UIBarButtonItem(title: "結束展開", style: UIBarButtonItemStyle.Plain, target: self, action: "doneExpand:")
        doneButton.tintColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.frame = CGRectMake(0, 0, self.frame.width, 44)
        self.addSubview(toolBar)
        
        webView.frame = CGRectMake(0,  44, self.frame.width, self.frame.height-44)
    }
    
    func doneExpand(sender:UIButton!){
        let collectionView = superview as! UICollectionView
        for cell in collectionView.visibleCells(){
            cell.hidden = false
        }
        toolBar.removeFromSuperview()
        webView.frame = CGRectMake(8, progress.frame.origin.y+2, self.frame.width-16, 200)
        self.frame = self_frame
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if (keyPath == "estimatedProgress") {
            progress.hidden = self.webView.estimatedProgress == 1
            progress.setProgress(Float(self.webView.estimatedProgress), animated: true)
        }
    }
    
    /* Start the network activity indicator when the web view is loading */
    func webView(webView: WKWebView,didStartProvisionalNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    /* Stop the network activity indicator when the loading finishes */
    func webView(webView: WKWebView,didFinishNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        progress.setProgress(0.0, animated: false)
    }
    
    func webView(webView: WKWebView,decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse,
        decisionHandler: ((WKNavigationResponsePolicy) -> Void)){
            print(navigationResponse.response.MIMEType)
            decisionHandler(.Allow)
    }
    
}
