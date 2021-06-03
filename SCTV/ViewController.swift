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
import NVActivityIndicatorView

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
        let serverAddress = ad.undefinedUserRequestAddress
        
        // 엑티비티 인디케이터
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 162, y: 100, width: 50, height: 50),
                                                type: .circleStrokeSpin,
                                                color: .black,
                                                padding: 0)
        
        // 뷰에 인디케이터 삽입
        self.view.addSubview(indicator)
        
        AF.request(serverAddress , method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON() { response in
            indicator.startAnimating() // indicator 실행
            switch response.result {
            case .success:
                // 성공 시 처리
                print("성공")
                print(response)
                
                
                if let jsonObject = try! response.result.get() as? NSDictionary {
                    // let name = String(unicodeScalarLiteral: element["name"] as! String) // 유니코드로 이상하게 나오지 않도록 변환
                    let result = jsonObject["result"] as? Int
                    if let r = result {
                        if (r == 1) {
                            self.baseImage = jsonObject["image"] as? String
                            ad.baseUserImage = self.baseImage!
                            self.ResponseMessageAlert(title: "침입자 있음")
                        } else {
                            self.messageAlert(title: "침입자 없음", message: "")
                        }
                    }
                }
                // self.messageAlert(title: "요청 성공", message: "정상 처리되었습니다.")
            
            /*
             if let jsonObject = try! response.result.get() as? NSArray {
                 for json in jsonObject {
                     // print(json)
                     let element = json as! NSDictionary
                     // let name = String(unicodeScalarLiteral: element["name"] as! String) // 유니코드로 이상하게 나오지 않도록 변환
                     let name = element["name"] as? String
                     let content = element["content"] as? String
                     self.baseImage = element["image"] as? String
                     
                     if(name == self.tfName.text!) {
                         let parsedResponse = "name: \(name!)" + "\n"
                             + "content: \(content!)" + "\n\n\n"
                         
                         found = true
                         self.ResponseMessageAlert(message: parsedResponse)
                         break
                     }
                 }
             }
             if(found == false) {
                 self.messageAlert(message: "등록되지 않은 사용자입니다. 등록 후 사용해주세요.")
             }
             */

            case .failure:
                // 실패 시 처리
                print("실패")
                self.messageAlert(title: "서버 요청 실패", message: "서버 상태를 확인해주세요.")
            }
        }
    }
    
    @IBAction func btnRegistUser(_ sender: Any) {
        // 사용자 등록
        self.registAlert1()
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
//        guard let wvc = self.storyboard?.instantiateViewController(withIdentifier: "wvc") as? WebViewController else {
//            return
//        }
        let wvc = WebController()
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
        let ad = UIApplication.shared.delegate as! AppDelegate
        
        let param: [String: Any] = [
            "name" : "3번 사용자" as String,
            "Owner": 3 as Int,
            "content": "empty" as String,
            "image": ad.baseUserImage as String
        ]
        
        AF.request(ad.webServerIpAddress , method: .post, parameters: param, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
            switch response.result {
            case .success:
                // 등록 성공 시 로직 구현
                self.messageAlert(title: "사용자 등록 성공", message: "정상적으로 등록되었습니다.")
                print("registResponse: \(response)")

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
    
    private func ResponseMessageAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                
        // 이미지 파일을 가져와서 UIImage 형식으로 저장
        let dataDecoded: NSData? = NSData(base64Encoded: self.baseImage!, options: NSData.Base64DecodingOptions(rawValue: 0))
        let image: UIImage = UIImage(data: dataDecoded! as Data)!
        // let image = UIImage(named: "no_face.jpeg")
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
    
    private func registAlert2() {
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
    
    // name과 content를 얻는 alert
    func registAlert1() {
        let alert = UIAlertController(title: "사용자 등록", message: nil, preferredStyle: .alert)
        
        alert.addTextField { tf in
            tf.placeholder = "등록할 사용자 이름을 입력하세요"
        }
        alert.addTextField { tf in
            tf.placeholder = "특이사항을 입력하세요"
        }
        
        alert.addAction(UIAlertAction(title: "완료", style: .default) { _ in
            let ad = UIApplication.shared.delegate as! AppDelegate
            ad.name = alert.textFields?[0].text ?? ""
            ad.content = alert.textFields?[1].text ?? ""
            self.dismiss(animated: true, completion: nil)
            self.registAlert2()
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

