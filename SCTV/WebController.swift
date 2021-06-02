//
//  WebController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/06/03.
//

import UIKit
import WebKit // WebView 사용을 위한 패키지 임포트

class WebController: UIViewController, WKUIDelegate {
    var url: String?
    
//    @IBOutlet weak var myWebView: WKWebView!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
          let webConfiguration = WKWebViewConfiguration()
          webView = WKWebView(frame: .zero, configuration: webConfiguration)
          webView.uiDelegate = self
          view = webView
      }

    //웹뷰 로드 기능을 하는 함수 생성
    func loadWebPage(_ url:String) {
        // https://www.naver.com
        // url 확인 후 정상적인 url이 아니면 오류 알림창 띄움
        if( self.verifyUrl(urlString: url)) {
            let myUrl = URL(string: url)
            let myRequest = URLRequest(url: myUrl!)
            webView.load(myRequest)
        } else {
            let alert = UIAlertController(title: "URL 오류", message: "URL을 확인하세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // url validation method
    func verifyUrl (urlString: String?) -> Bool {
       if let urlString = urlString {
           if let url = NSURL(string: urlString) {
               return UIApplication.shared.canOpenURL(url as URL)
           }
       }
       return false
   }
    
    override func viewDidAppear(_ animated: Bool) {
        loadWebPage(url!)
    }
}
