import UIKit
import Alamofire

class ApiSendViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnApiSend(_ sender: Any) {
        apiSerch()
    }
    
    @IBAction func btnRegist(_ sender: Any) {
        apiRegist()
    }
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirth: UITextField!
    
    func showCCTV() {
        // 추후 cctv 스트리밍 화면으로 연결되도록 구현할 예정
    }
    
    // MARK:- API GET/POST
    private func apiSerch() {
        //접근하고자 하는 URL 정보
        // let URL = "https://jsonplaceholder.typicode.com/todos/3"
        let URL = "http://1.244.160.11:8000/addresses/"
        
        // 1. 전송할 값 준비
//        let param: Parameters = [
//            "userId": userId,
//            "userPassword": userPassword]
        
        // 전송
        AF.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default).validate().responseJSON() { response in
            switch response.result {
            case .success:
//                if let jsonObject = try! response.result.get() as? [String: Any] {
//                    let userId = jsonObject["userId"] as? Int
//                    let id = jsonObject["id"] as? Int
//                    let title = jsonObject["title"] as? String
//                    let completed = jsonObject["completed"] as? Bool
//
//                    let parsedResponse = "userId: \(userId!)" + "\n"
//                        + "id: \(id!)" + "\n"
//                        + "title: \(title!)" + "\n"
//                        + "completed: \(completed!)" + "\n\n\n"
//
//                    self.ResponseMessageAlert(message: parsedResponse)
//                }

                var found = false
                
                // 이름, 생년월일, 성별, 사진 JSON
                if let jsonObject = try! response.result.get() as? NSArray {
                    for json in jsonObject {
                        let element = json as! NSDictionary
                        
                        let name = element["name"] as? String
                        let birth = element["birth"] as? String
                        let gender = element["gender"] as? String
                        // let image_field = element["image_field"] as? String
                        // let created = element["created"] as? String
                        
                        if(name == self.tfName.text!) {
                            let parsedResponse = "name: \(name!)" + "\n"
                                + "birth: \(birth!)" + "\n"
                                + "gender: \(gender!)" + "\n"
                                //+ "created: \(created!)" + "\n"
                            self.ResponseMessageAlert(message: parsedResponse)
                            found = true
                            break
                        }
                        
                    }
                    if(found == false) {
                        self.messageAlert(message: "등록되지 않은 사용자입니다. 등록 후 사용해주세요.")
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    private func apiRegist() {
        let URL = "http://1.244.160.11:8000/addresses/"
        let date = DateFormatter()
        date.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let param: [String: String] = [
            "name": tfName.text! ,
            "birth": tfBirth.text!,
            "gender": "수컷",
            "image_field": "",
            "created": date.string(from: Date())
        ]

        AF.request(URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
            // response.data
         }
    }
    
    
    
    // MARK:- Alert
    private func ResponseMessageAlert(message m: String) {
        let alert = UIAlertController(title: "요청 전송 완료", message: "응답메시지: \n" + m, preferredStyle: .alert)
        
        // URL에 있는 이미지 파일을 가져와서 UIImage 형식으로 저장
        var image: UIImage?
        let url = URL(string: "https://img1.daumcdn.net/thumb/R720x0.q80/?scode=mtistory2&fname=http%3A%2F%2Fcfile7.uf.tistory.com%2Fimage%2F24283C3858F778CA2EFABE")
        
        do {
            let data = try Data(contentsOf: url!)
            image = UIImage(data: data)
        } catch {
            
        }

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
        present(alert, animated: true, completion: nil)
    }
    
    private func messageAlert(message msg: String) {
        let alert = UIAlertController(title: "알림", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
