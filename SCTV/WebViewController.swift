//
//  WebViewController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/05/13.
//

import UIKit
import WebKit //WebView 사용을 위한 패키지 임포트

class WebViewController: UIViewController {

    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // viewDidLoad() 바로 다음에 함수를 호출하여 웹뷰가 즉시 출력될 수 있도록 작성
        loadWebPage("http://115.86.241.6:81/stream")
        
    }
    //웹뷰 로드 기능을 하는 함수 생성
    func loadWebPage(_ url:String) {
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        myWebView.load(myRequest)
        
    }
    
    // 이전 버튼 작동을 위한 구문
    @IBAction func onBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

