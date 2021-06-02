//
//  ViewController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/06/01.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var userName = ""
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 모서리 굴곡 설정
        showCCTVOutlet.layer.cornerRadius = 10
        eventExistRequestOutlet.layer.cornerRadius = 10
        searchUserOutlet.layer.cornerRadius = 10
        notSetFuncionOutlet.layer.cornerRadius = 10
    }
    
    @IBOutlet weak var userOutlet: UIButton!
    @IBOutlet weak var showCCTVOutlet: UIButton!
    @IBOutlet weak var eventExistRequestOutlet: UIButton!
    @IBOutlet weak var searchUserOutlet: UIButton!
    @IBOutlet weak var notSetFuncionOutlet: UIButton!
    
    
    var baseImage: String?
    
    // (CCTV 보기) 버튼
    @IBAction func btnShowCCTV(_ sender: Any) {
        showCCTV()
    }
    
    // (침입자 확인) 버튼, 침입자 내역이 있는지 서버에 요청하는 버튼
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
                self.messageAlert(title: "요청 성공", message: "정상 처리되었습니다.")
                
            case .failure:
                // 실패 시 처리
                print("실패")
                self.messageAlert(title: "서버 요청 실패", message: "서버 상태를 확인해주세요.")
            }
        }
    }
    
    @IBAction func btnSearchUser(_ sender: Any) {
        searchUserAlert()
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
    
    // MARK:- Alert
    func messageAlert(title: String, message msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    func searchUserAlert() {
        let alert = UIAlertController(title: "사용자 조회", message: nil, preferredStyle: .alert)
        
        // 사용자 이름 입력 텍스트 필드 추가
        alert.addTextField { textField in
            textField.placeholder = "이름을 입력하세요."
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
        
        // 사용자 아이디 입력 텍스트 필드 추가
        alert.addTextField { textField in
            textField.placeholder = "아이디를 입력하세요."
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
        
        alert.addAction(UIAlertAction(title: "조회하기", style: .default) { _ in
            self.userName = alert.textFields?[0].text ?? "입력된 사용자 이름 없음"
            self.userId = alert.textFields?[1].text ?? "입력된 사용자 아이디 없음"
            self.messageAlert(title: "사용자 조회 버튼 테스트", message: "입력된 사용자 이름: \(self.userName)\n입력된 사용자 아이디: \(self.userId)")
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}





