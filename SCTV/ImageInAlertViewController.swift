//
//  ImageInAlertViewController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/05/19.
//

import UIKit

class ImageInAlertViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        //url에 정확한 이미지 url 주소를 넣는다.
        let url = URL(string: "http://verona-api.municipiumstaging.it/system/images/image/image/22/app_1920_1280_4.jpg")
        var image : UIImage? //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
        
        //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
        DispatchQueue.global().async { let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                image = UIImage(data: data!)
            }
        }

        let iconV = UIImageView(image: image) // 이미지 객체를 이용해서 화면에 표시하는 뷰의 일종
          
        //2. 이미지 뷰의 영역과 위치를 지정
        iconV.frame = CGRect(x:0, y:0, width:(image?.size.width)!,height:(image?.size.height)!)
      
        //3. 루트뷰에 이미지 뷰를 추가
        self.view.addSubview(iconV)
      
        //preferredContentSize 속성을 통해 외부 객체가 ImageViewController를 나타낼 때 참고할 사이즈 지정
        //4.  외부에서 참조할 뷰 컨트롤러 사이즈를 이미지 크기와 동일하게 설정 + 10은 알림창에 이미지가 표시될때 아래 여백 주기
        self.preferredContentSize = CGSize(width:(image?.size.width)!,height:(image?.size.height)!+10)
    }
}
