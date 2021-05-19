import UIKit
import Alamofire

class ApiSendViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnApiSend(_ sender: Any) {
        send()
    }
        
    
    private func send() {
        //접근하고자 하는 URL 정보
        let URL = "https://jsonplaceholder.typicode.com/todos/3"

        // 1. 전송할 값 준비
//        let param: Parameters = [
//            "userId": userId,
//            "userPassword": userPassword]
        
        // 전송
        AF.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let jsonObject = try! response.result.get() as? [String: Any] {
                    let userId = jsonObject["userId"] as? Int
                    let id = jsonObject["id"] as? Int
                    let title = jsonObject["title"] as? String
                    let completed = jsonObject["completed"] as? Bool
                    
                    let parsedResponse = "userId: \(userId!)" + "\n"
                        + "id: \(id!)" + "\n"
                        + "title: \(title!)" + "\n"
                        + "completed: \(completed!)" + "\n\n\n"
                    
                    self.ResponseMessageAlert(message: parsedResponse)
                }
            case .failure(let error):
                print(error)
                return
            }
        }
        
        /*
         이름, 생년월일, 성별, 사진 JSON
         if let jsonObject = try! response.result.get() as? [String: Any] {
             let userId = jsonObject["이름"] as? String
             let id = jsonObject["생년월일"] as? String
             let title = jsonObject["성별"] as? String
             let completed = jsonObject["사진"] as?
             
             let parsedResponse = "userId: \(userId!)" + "\n"
                 + "id: \(id!)" + "\n"
                 + "title: \(title!)" + "\n"
                 + "completed: \(completed!)" + "\n"
             
             self.ResponseMessageAlert(message: parsedResponse)
         }
         
         */
    }
    
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
    
    func showCCTV() {
        // 추후 cctv 스트리밍 화면으로 연결되도록 구현할 예정
    }
}
