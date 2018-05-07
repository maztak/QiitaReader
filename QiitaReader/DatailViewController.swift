//
//  DatailViewController.swift
//  
//
//  Created by Takuya Matsuda on 2018/03/27.
//

import UIKit
import TOWebViewController

class DetailViewController: TOWebViewController {
    var webview: UIWebView = UIWebView()
//    var entry: Article?
    var entry: ArticleByHimotoki? //test
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webview.frame = self.view.bounds
        self.webview.delegate = self;
        self.view.addSubview(self.webview)
        
        let url = NSURL(string: self.entry!.url)
        let request = NSURLRequest(url: url! as URL)
        
        self.webview.loadRequest(request as URLRequest)
    }
    
    
    override func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    override func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

