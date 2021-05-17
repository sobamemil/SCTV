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
        AF.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON() { response in
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
                        + "completed: \(completed!)" + "\n"
                    
                    //showAlert(parsedResponse)
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    
}
