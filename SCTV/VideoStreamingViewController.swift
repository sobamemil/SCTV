//
//  VideoStreamingViewController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/05/13.
//

import UIKit
import AVKit
import AVFoundation


class VideoStreamingViewController: UIViewController, UITextFieldDelegate {

    var ipAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 테스트 ip 주소 : http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
    
    // cctv 영상 재생 버튼 클릭 시 호출
    @IBAction func btnStartStreaming(_ sender: UIButton) {
        if let address = tfIpAddress.text { // textField로부터 ip주소를 가져옴
            let url = NSURL(string: address)! // NSURL 생성
            startStreaming(url: url) // 스트리밍 시작 메소드 호출
        }
        else { // textField에 값이 없으면 예외처리
            
        }
    }
    
    @IBOutlet var tfIpAddress: UITextField! {
        didSet {
            tfIpAddress.delegate = self
            tfIpAddress.returnKeyType = .done
            let ad = UIApplication.shared.delegate as? AppDelegate
            ad?.ipAddress = tfIpAddress.text
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let ad = UIApplication.shared.delegate as? AppDelegate
        ad?.ipAddress = textField.text
        print(ad?.ipAddress)
        print(ad?.baseUserImage)
    }
    
    @IBAction func btnShowWeb(_ sender: Any) {
        guard let wvc = self.storyboard?.instantiateViewController(identifier: "wvc") as? WebViewController else {
            return
        }
        
        if let address = tfIpAddress.text {
            wvc.url = address
            self.present(wvc, animated: true, completion: nil)
        }
    }
    
    
    private func startStreaming(url: NSURL){
        
        // avplayerViewController의 인스턴스를 생성한다.
        let playerController = AVPlayerViewController()
        
        // 앞에서 얻은 비디오 url로 초기화된 avplayer의 인스턴스를 생성한다.
        let player = AVPlayer(url: url as URL)
        
        // AVPlayViewController의 player 속성에 위에서 생성한 avplayer인스턴스를 할당한다.
        playerController.player = player
        
        // 비디오를 재생한다.
        self.present(playerController, animated:true){
            player.play()
        }
    }
    
    // 화면 터치 시 키보드 자판이 내려가도록 하는 부분
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 키보드의 Done, 완료 버튼 클릭 시 키보드가 내려가도록 구현
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfIpAddress.resignFirstResponder()
        return true
    }

}
