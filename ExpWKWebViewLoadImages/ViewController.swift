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
    
    enum BaseURLTarget {
        
        // The App's Bundle folder
        case bundleRootFolder
        // The App's Library folder
        case libraryFolder
        
        var url: URL? {
            switch self {
                
            case .bundleRootFolder:
                return Bundle.main.bundleURL
                
            case .libraryFolder:
                do {
                    return try FileManager.default.url(for: FileManager.SearchPathDirectory.libraryDirectory,
                                                       in: FileManager.SearchPathDomainMask.userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false)
                } catch {
                    return nil
                }
            }
        }
    }
    
    // MARK: - Instance Members
    
    @IBOutlet weak var buttonControlView: UIView!

    let webView = WKWebView()
    
    let websiteURL = URL(string: "http://stackoverflow.com/q/39901982/2062785")
    
    let imageURL = URL(string: "https://cdn.sstatic.net/Sites/stackoverflow/company/img/logos/so/so-icon.png")
    
    var imageName: String {
        return imageURL!.lastPathComponent
    }
    
    var htmlString: String {
        return "<html><head><title>Testing images in a WKWebView</title></head><body style=\"font-size: 2rem\"><h1>This is the Heading</h1><p>... and this is a paragraph. Both are contained in an HTML string that is loaded inside the <b>WKWebView</b> using its <b>loadHTMLString(String, baseURL: URL?)</b> method.</p><p>In the following line an image should be displayed:</p><p><img src=\"\(imageName)\" /></p><p>For some mysterious reason, it works in Simulator but it doesn't on a real device. So sad. :(</p></body></html>"
    }
    
    // MARK: - Initial Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        try! downloadAndStoreImageInLibraryFolder()
    }
    
    override func viewDidLayoutSubviews() {
        // Position and size webView properly
        var frame = view.bounds
        frame.origin.y += 20 // Avoid overlap with status bar
        frame.size.height -= buttonControlView.frame.size.height // Don't cover button control view
        webView.frame = frame
    }
    
    // MARK: - Button Actions
    
    @IBAction func loadFromWebButtonTapped(_ sender: AnyObject) {
        loadWebsite()
    }
    
    @IBAction func loadFromBundleButtonTapped(_ sender: AnyObject) {
        loadLocalHTMLString(with: .bundleRootFolder)
    }
    
    @IBAction func loadFromLibraryButtonTapped(_ sender: AnyObject) {
        loadLocalHTMLString(with: .libraryFolder)
    }
    
    // MARK: - Load Webview Content
    
    func loadWebsite() {
        print("Loading Webview with URL: \(websiteURL)\n")
        let request = URLRequest(url: websiteURL!)
        webView.load(request)
    }
    
    func loadLocalHTMLString(with baseURLTarget: BaseURLTarget) {
        print("Loading Webview with baseURL: \(baseURLTarget.url)\n")
        print("--- Contents of directory: ---\n")
        printContentsOfDirectory(at: baseURLTarget.url)
        webView.loadHTMLString(htmlString, baseURL: baseURLTarget.url)
    }
    
    // MARK: - Helpers
    
    func downloadAndStoreImageInLibraryFolder() throws {
        let data = try Data(contentsOf: imageURL!)
        let targetImageURL = BaseURLTarget.libraryFolder.url?.appendingPathComponent(imageName)
        if let targetImageURL = targetImageURL {
            try data.write(to: targetImageURL)
        }
    }
    
    func printContentsOfDirectory(at URL: URL?) {
        let contents = try! FileManager.default.contentsOfDirectory(at: URL!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        for item in contents {
            print("\t", item.resolvingSymlinksInPath(), "\n")
        }
    }

}

