//
//  ViewController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/06/01.
//

import UIKit
import Alamofire
import MessageUI
import WebKit

class ViewController: UIViewController {
    
    var userName = ""
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 모서리 굴곡 설정
        showCCTVOutlet.layer.cornerRadius = 10
        eventExistRequestOutlet.layer.cornerRadius = 10
        registUserOutlet.layer.cornerRadius = 10
        notSetFuncionOutlet.layer.cornerRadius = 10
    }
    
    @IBOutlet weak var userOutlet: UIButton!
    @IBOutlet weak var showCCTVOutlet: UIButton!
    @IBOutlet weak var eventExistRequestOutlet: UIButton!
    @IBOutlet weak var registUserOutlet: UIButton!
    @IBOutlet weak var notSetFuncionOutlet: UIButton!
    
    var baseImage: String?
    
    // (CCTV 보기) 버튼
    @IBAction func btnShowCCTV(_ sender: Any) {
        showCCTV()
    }
    
    // (침입자 확인) 버튼, 침입자 내역이 있는지 서버에 요청하는 버튼
    @IBAction func btnEventRequest(_ sender: Any) {
        let ad = UIApplication.shared.delegate as! AppDelegate
        let serverAddress = ad.webServerIpAddress
            print(serverAddress)
//        let param = [
//            "name" : "심찬영",
//            "image" : "bae64String",
//            "created_at" : "now"
//        ]
        
        let param: [String: Any] = [
            "content" : "chanyeong" as String,
            "image" : "base64String" as String
        ]
        
        DispatchQueue.main.async {
            AF.request(serverAddress , method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON() { response in
                switch response.result {
                case .success:
                    // 성공 시 처리
                    print("성공")
                    print(response)
                    
                    self.ResponseMessageAlert(title: "침입자 있음", "침입자 얼굴: ")
                    // self.messageAlert(title: "요청 성공", message: "정상 처리되었습니다.")

                case .failure:
                    // 실패 시 처리
                    print("실패")
                    print(response)
                    self.messageAlert(title: "서버 요청 실패", message: "서버 상태를 확인해주세요.")
                }
            }
        }
        
//        let url = "http://192.168.35.194:80/testapp/Test/"
//
//        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
//            switch response.result {
//            case .success:
//                // 등록 성공 시 로직 구현
//                //self.messageAlert(message: "정상적으로 등록되었습니다.")
//                print(response)
//
//            case .failure:
//                // 등록 실패 시 로직 구현
//                //self.messageAlert(message: "등록에 실패하였습니다.")
//                NSLog("regist error (POST)")
//            }
//         }
    }
    
    @IBAction func btnRegistUser(_ sender: Any) {
        // searchUserAlert()
        // 사용자 등록
        self.registAlert()
    }
    
    
    @IBAction func btnReport(_ sender: Any) {
        // 메시지로 신고
        sendReportMessage()
    }
    
    
    @IBAction func btnSetting(_ sender: Any) {
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as? SettingViewController else {
            messageAlert(title: "실패", message: "SettingViewController를 객체화하지 못하였습니다.")
            return
        }
        
        self.present(svc, animated: true, completion: nil)
    }
    
    func showCCTV() {
        // 추후 cctv 스트리밍 화면으로 연결되도록 구현할 예정
        guard let wvc = self.storyboard?.instantiateViewController(withIdentifier: "wvc") as? WebViewController else {
            return
        }
        
        let ad = UIApplication.shared.delegate as? AppDelegate
        if let ip = ad?.CCTVipAddress {
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
    
    func apiRegist() {
        let url = "http://1.244.160.11:8000/cctvapp/Person/"

        let ad = UIApplication.shared.delegate as! AppDelegate
        
        let param: [String: String] = [
            "User_id": "1",
            "name": (UIApplication.shared.delegate as! AppDelegate).name ?? "이름없음" ,
            "content": "empty",
            "image": ad.baseUserImage
        ]
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
            switch response.result {
            case .success:
                // 등록 성공 시 로직 구현
                self.messageAlert(title: "사용자 등록 성공", message: "정상적으로 등록되었습니다.")
                print(response)

            case .failure:
                // 등록 실패 시 로직 구현
                self.messageAlert(title: "사용자 등록 실패", message: "등록에 실패하였습니다.")
                NSLog("regist error (POST)")
            }
         }
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
    
    private func ResponseMessageAlert(title: String, _ m: String) {
        let alert = UIAlertController(title: "요청 전송 완료", message: "응답메시지: \n" + m, preferredStyle: .alert)
                
        // 이미지 파일을 가져와서 UIImage 형식으로 저장
        let dataDecoded:NSData = NSData(base64Encoded: self.baseImage!, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let image: UIImage = UIImage(data: dataDecoded as Data)!
//        let url = URL(string: "https://img1.daumcdn.net/thumb/R720x0.q80/?scode=mtistory2&fname=http%3A%2F%2Fcfile7.uf.tistory.com%2Fimage%2F24283C3858F778CA2EFABE")
//
        
//        do {
//            let data = try Data(contentsOf: url!)
//            image = UIImage(data: data)
//        } catch {
//
//        }

        // 이미지 크기 설정
        let imageView = UIImageView(frame: CGRect(x: 60, y: 125, width: 150, height: 140))
        
        // imageView에 이미지 삽입
        imageView.image = image
        
        // alert의 subView로 imageView를 추가 -> alert에서 이미지 감상 가능
        alert.view.addSubview(imageView)
        
        let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
        let width = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        alert.view.addConstraint(height)
        alert.view.addConstraint(width)
        
        
//        let imageVC = ImageInAlertViewController()
//        alert.setValue(imageVC, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "CCTV 보기", style: .destructive) { (_) in
            self.showCCTV()
        })
        
        // 알림창을 띄움
        self.present(alert, animated: true, completion: nil)
    }
    
    private func registAlert() {
        let alert = UIAlertController(title: "사용자등록", message: "사용자 등록 시 얼굴을 5초간 촬영하여야 합니다.\n촬영을 시작하시려면 '촬영하기' 버튼을 눌러주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "촬영하기", style: .default) { _ in
            guard let cpvc = self.storyboard?.instantiateViewController(withIdentifier: "cpvc") as? CapturePreViewViewController else {
                print("CapturePreViewViewController 인스턴스 생성 실패")
                return
            }
            self.present(cpvc, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK:- Send Message to report
extension ViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // 메시지 전송 후 애플리케이션 화면을 다시 띄움
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendReportMessage() {
        if MFMessageComposeViewController.canSendText() {
            let ad = UIApplication.shared.delegate as! AppDelegate
            let recipients:[String] = [ad.reportNumber] // 전화번호
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            messageController.recipients = recipients
            messageController.body = "주소: \(ad.userAddress)\n도둑이 침입했습니다!!!" // contents
            self.present(messageController, animated: true, completion: nil)
        }
    }
}





