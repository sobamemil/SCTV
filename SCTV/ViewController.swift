//
//  ViewController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/06/01.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    @IBOutlet weak var userOutlet: UIButton!
    
    var baseImage: String?
    
    // CCTV 보기 버튼
    @IBAction func btnShowCCTV(_ sender: Any) {
        showCCTV()
    }
    
    
    func showCCTV() {
        // 추후 cctv 스트리밍 화면으로 연결되도록 구현할 예정
        guard let wvc = self.storyboard?.instantiateViewController(withIdentifier: "wvc") as? WebViewController else {
            return
        }
                
        let ad = UIApplication.shared.delegate as? AppDelegate
        if let ip = ad?.ipAddress {
            wvc.url = ip
            present(wvc, animated: true, completion: nil)
        }
    }
}
