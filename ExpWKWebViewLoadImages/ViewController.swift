//
//  ViewController.swift
//  ExpWKWebViewLoadImages
//
//  Created by Mischa Hildebrand on 06/10/16.
//  Copyright © 2016 Kupferwerk. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    let webView = WKWebView()
    
    let imageURL = URL(string: "https://cdn.sstatic.net/Sites/stackoverflow/company/img/logos/so/so-icon.png")
    
    var imageName: String {
        return "image" + (imageURL?.lastPathComponent)!
    }
    
    let htmlName = "htmlFile.html"
    
    var htmlURL: URL {
        return libraryURL.appendingPathComponent(htmlName)
    }
    
    var htmlString: String {
        return "<html><head><title>Testing images in a WKWebView</title></head><body style=\"font-size: 2rem\"><h1>This is the Heading</h1><p>... and this is a paragraph. Both are contained in an HTML string that is loaded inside the <b>WKWebView</b> using its <b>loadHTMLString(String, baseURL: URL?)</b> method.</p><p>In the following line an image should be displayed:</p><p><img src=\"\(imageName)\" /></p><p>For some mysterious reason, it works in Simulator but it doesn't on a real device. So sad. :(</p></body></html>"
    }
    
    let libraryURL = try! FileManager.default.url(for: FileManager.SearchPathDirectory.libraryDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask,
                                                 appropriateFor: nil,
                                                 create: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWebView()
        
        try! htmlString.write(to: htmlURL, atomically: true, encoding: .utf8)
        
        try! downloadAndStoreImageInLibraryFolder()
        
        webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
        
        //webView.loadHTMLString(htmlString, baseURL: libraryURL)
    }
    
    func addWebView() {
        view.addSubview(webView)
        webView.frame = view.bounds.insetBy(dx: 0, dy: 20)
    }
    
    func downloadAndStoreImageInLibraryFolder() throws {
        let data = try Data(contentsOf: imageURL!)
        let targetImageURL = libraryURL.appendingPathComponent(imageName)
        try data.write(to: targetImageURL)
    }
    
    func loadWebsite() {
        let request = URLRequest(url: URL(string: "https://www.google.de")!)
        webView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

