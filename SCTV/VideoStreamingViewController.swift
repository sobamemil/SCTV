//
//  VideoStreamingViewController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/05/13.
//

import UIKit
import AVKit
import AVFoundation

class VideoStreamingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
    
    // cctv 영상 재생 버튼 클릭 시 호출
    @IBAction func btnStartStreaming(_ sender: UIButton) {
        if let address = tfIpAddress.text { // textField로부터 ip주소를 가져옴
            print(address)
            let url = NSURL(string: address)! // NSURL 생성
            startStreaming(url: url) // 스트리밍 시작 메소드 호출
        }
        else { // textField에 값이 없으면 예외처리
        }
    }
    
    @IBOutlet weak var tfIpAddress: UITextField!
    
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
}
