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
        
        // 모서리 굴곡 설정
        showCCTVOutlet.layer.cornerRadius = 10
    }
    
    @IBOutlet weak var userOutlet: UIButton!
    @IBOutlet weak var showCCTVOutlet: UIButton!
    
    var baseImage: String?
    
    // CCTV 보기 버튼
    @IBAction func btnShowCCTV(_ sender: Any) {
        showCCTV()
    }
    
    // 침입자 내역이 있는지 서버에 요청하는 버튼
    @IBAction func btnEventRequest(_ sender: Any) {
        let ad = UIApplication.shared.delegate as! AppDelegate
        
        let param = [
            "param" : "request"
        ]
        
        AF.request(ad.ipAddress , method: .get, parameters: param, encoding: JSONEncoding.default).validate().responseJSON() { response in
            switch response.result {
            case .success:
                // 성공 시 처리
                print("성공")
                
            case .failure:
                // 실패 시 처리
                print("실패")
            }
        }
        
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
