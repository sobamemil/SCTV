import UIKit
import Alamofire


class ApiSendViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnApiSend(_ sender: Any) {
        apiSerch()
        // showCCTV()
    }
    
    @IBAction func btnRegist(_ sender: Any) {
        // 사용자 얼굴 등록을 할 것인지 물어보는 alert 실행
        registAlert()
        
        // apiRegist()
        // apiImageSend()
    }
    
    @IBOutlet var tfName: UITextField! {
        didSet {
            tfName.delegate = self
            tfName.returnKeyType = .done
        }
    }
    
    @IBOutlet var tfBirth: UITextField!
    @IBOutlet var imgvImage: UIImageView!
    
    var baseImage: String?
    
    func showCCTV() {
        // 추후 cctv 스트리밍 화면으로 연결되도록 구현할 예정
        guard let wvc = self.storyboard?.instantiateViewController(withIdentifier: "wvc") as? WebController else {
            return
        }
                
        let ad = UIApplication.shared.delegate as? AppDelegate
        if let ip = ad?.CCTVipAddress {
            wvc.url = ip
            present(wvc, animated: true, completion: nil)
        }
        
//        if let address = vsvc.tfIpAddress.text {
//            wvc.url = address
//            self.present(wvc, animated: true, completion: nil)
//        }
    }
    
    // MARK:- API GET/POST
    private func apiSerch() {
        //접근하고자 하는 URL 정보
        // let URL = "https://jsonplaceholder.typicode.com/todos/3"
        let url = "http://1.244.160.11:8000/cctvapp/Person/"
        //let url = (UIApplication.shared.delegate as! AppDelegate).webServerIpAddress
        
        // 1. 전송할 값 준비
        let param: [String:String] = [
            "name": tfName.text!,
            ]

        // 전송
        AF.request(url, method: .get, parameters: param, encoding: JSONEncoding.default, headers: [:]).responseJSON() { response in
            switch response.result {
            case .success:

                var found = false
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
                
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func apiRegist() {
        let ad = UIApplication.shared.delegate as! AppDelegate
        print("ad.name: \(ad.name)\nad.content: \(ad.content)")
        
        let param: [String: Any] = [
            "name" : ad.name as String,
            "content": ad.content as String,
            "image": ad.baseUserImage as String
        ]
        
        AF.request(ad.webServerIpAddress, method: .post, parameters: param, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
            switch response.result {
            case .success:
                // 등록 성공 시 로직 구현
                self.messageAlert(message: "정상적으로 등록되었습니다.")
                print(response)

            case .failure:
                // 등록 실패 시 로직 구현
                self.messageAlert(message: "등록에 실패하였습니다.")
                NSLog("regist error (POST)")
            }
         }
    }
    
//    private func apiImageSend() {
//        let url = "http://1.244.160.11:8000/cctvapp/Person/"
//        // let url = "https://ptsv2.com/t/a8ag5-1622037163/post"
//        // let URL = "https://reqbin.com/echo/post/json"
//
//        let urlImage = URL(string: "https://img1.daumcdn.net/thumb/R720x0.q80/?scode=mtistory2&fname=http%3A%2F%2Fcfile7.uf.tistory.com%2Fimage%2F24283C3858F778CA2EFABE")
//
//        let image = UIImage(named: "cat.jpeg")!
//
//        let param: [String: String] = [
//            "name": tfName.text!,
//            "content": "내용 없음...", // tfcontent.text!,
//            "image": image.toJpegString(compressionQuality: 1)!
//        ]
//
//        let imageData = image.jpegData(compressionQuality: 0.5)
//
//        self.imgvImage.image = UIImage(data: try! Data(contentsOf: urlImage!))
//
//
////        AF.upload(
////                        multipartFormData: { multipartFormData in
////                            multipartFormData.append(imageData!, withName: "image", fileName: "cat.jpeg", mimeType: "image/jpeg")
////                    },
////            to: url).responseJSON { response in
////                print(response)
////            }
//
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(imageData!, withName: "image", fileName: "cat.jpg", mimeType: "image/jpg")
//            multipartFormData.append(Data(self.tfName.text!.utf8), withName: "name")
//            multipartFormData.append(Data("empty content".utf8), withName: "content")
//        }, to: url, method: .post).responseString { response in
//            print(response)
//        }
//    }

//        AF.request(URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
//            switch response.result {
//            case .success:
//                // 등록 성공 시
//                self.messageAlert(message: "정상적으로 등록되었습니다.")
//                print(response)
//            case .failure:
//                // 등록 실패 시 로직 구현
//                self.messageAlert(message: "등록에 실패하였습니다.")
//                NSLog("regist error (POST)")
//            }
//        }
//    }
    
    
    
    // MARK:- Alert
    private func ResponseMessageAlert(message m: String) {
        let alert = UIAlertController(title: "요청 전송 완료", message: "응답메시지: \n" + m, preferredStyle: .alert)
                
        // 이미지 파일을 가져와서 UIImage 형식으로 저장
        let dataDecoded:NSData = NSData(base64Encoded: self.baseImage!, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let image: UIImage = UIImage(data: dataDecoded as Data)!
        
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
        self.topViewController()!.present(alert, animated: true, completion: nil)
    }
    
    func messageAlert(message msg: String) {
        let alert = UIAlertController(title: "알림", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.topViewController()!.present(alert, animated: true, completion: nil)
    }
    
    private func registAlert() {
        let alert = UIAlertController(title: "사용자등록", message: "사용자 등록 시 얼굴을 5초간 촬영하여야 합니다.\n촬영을 시작하시려면 '촬영하기' 버튼을 눌러주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "촬영하기", style: .default) { _ in
            guard let cpvc = self.storyboard?.instantiateViewController(withIdentifier: "cpvc") as? CapturePreViewViewController else {
                print("CapturePreViewViewController 인스턴스 생성 실패")
                return
            }
            self.topViewController()!.present(cpvc, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        
        self.topViewController()!.present(alert, animated: true, completion: nil)
    }
    

    

    
    
    // MARK:- KEYBOARD SETTING
    // 화면 터치 시 키보드 자판이 내려가도록 하는 부분
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 키보드의 Done, 완료 버튼 클릭 시 키보드가 내려가도록 구현
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfName.resignFirstResponder()
        return true
    }
}


// MARK:- Type Convertor
extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}


// MARK:- topViewController
extension ApiSendViewController {
    func topViewController() -> UIViewController? {
        if let keyWindow = UIApplication.shared.keyWindow {
            if var viewController = keyWindow.rootViewController {
                while viewController.presentedViewController != nil {
                    viewController = viewController.presentedViewController!
                }
                print("topViewController -> \(String(describing: viewController))")
                return viewController
            }
        }
        return nil
    }
}


// MARK:- UITextFieldDelegate
extension ApiSendViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        (UIApplication.shared.delegate as! AppDelegate).name = self.tfName.text!
    }
}
