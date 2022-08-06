//
//  TVIntoWebViewController.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/06.
//

import UIKit
import WebKit

final class TVIntoWebViewController: UIViewController {

    let tmdbAPIManager = TMDBAPIManager.shared
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var xmarkButton: UIButton!
    
    var trendData: TrendData?
    let introBaseSite = "YouTube"

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self, #function)
        webView.navigationDelegate = self
        fetchIntoURL()
        setUI()
    }
    
    @IBAction func xmarkButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension TVIntoWebViewController {
    
    func setUI() {
        // TODO: UI 다듬기
    }
    
    func fetchIntoURL() {
        guard let tvID = trendData?.tvID else { return }
        
        tmdbAPIManager.fetchTVIntoAPI(tvID: tvID) { intoSite, introKey in
            if intoSite != self.introBaseSite { return }
            
            DispatchQueue.main.async {
                self.openpage(urlStr: "\(EndPoint.youtubeURL)\(introKey)")
                print(introKey)
                print(#function, "done")
            }
        }
    }
}

extension TVIntoWebViewController: WKNavigationDelegate {
    
    func openpage(urlStr: String) {
        
        guard let url = URL(string: urlStr) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
