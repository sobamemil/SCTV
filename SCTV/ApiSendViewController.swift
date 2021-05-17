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
        let URL = "https://jsonplaceholder.typicode.com/todos/1"
        
//        //전송할 파라미터 정보
//        let PARAM:Parameters = [
//            "NAME":"손흥민",
//            "BORN": 1992,
//            "JOB": "축구선수"
//        ]
        
        //위의 URL와 파라미터를 담아서 GET 방식으로 통신하며, statusCode가 200번대(정상적인 통신) 인지 유효성 검사 진행
        let alamo = AF.request(URL, method: .get, parameters: nil).validate(statusCode: 200..<300)
        
        //결과값으로 문자열을 받을 때 사용
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success(let value):
                print(value)
                
            //통신실패
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
            }
        }
    }
}
