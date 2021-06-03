//
//  CapturePreViewViewController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/05/27.
//

import UIKit
import AVFoundation
import CoreVideo

class CapturePreViewViewController: UIViewController {

    let videoCapture: VideoCapture = VideoCapture()
    var imageCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoCapture.delegate = self
    }
    
    @IBOutlet weak var stateOutlet: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        if self.videoCapture.initCamera(){
            (self.previewView.layer as! AVCaptureVideoPreviewLayer).session =
                self.videoCapture.captureSession
            
            (self.previewView.layer as! AVCaptureVideoPreviewLayer).videoGravity =
                AVLayerVideoGravity.resizeAspectFill
            
            self.videoCapture.asyncStartCapturing()
        } else{
            fatalError("Fail to init Video Capture")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.videoCapture.asyncStopCapturing()
    }
    
    @IBOutlet var previewView: UIView!
    
    @IBAction func btnDone(_ sender: Any) {
        let asvc = ApiSendViewController()
        
        self.dismiss(animated: true) {
            asvc.apiRegist()
        }
    }
}


// MARK: - VideoCaptureDelegate
extension CapturePreViewViewController: VideoCaptureDelegate{
    
    func onFrameCaptured(videoCapture: VideoCapture,pixelBuffer:CVPixelBuffer?,timestamp:CMTime){
        
        guard let pixelBuffer = pixelBuffer else{ return }
        
        // 모델 학습용 사진 준비
        let uiImage = UIImage(ciImage: CIImage(cvImageBuffer: pixelBuffer).resize(size: CGSize(width: 400, height: 600)))
        let baseImage = uiImage.jpegData(compressionQuality: 0.5)!.base64EncodedString()
        
        DispatchQueue.main.async {
            // 70장만 서버로 보냄
            if(!(self.imageCount > 24)) {
                // AppDelegate의 baseUserImage에 base64로 인코딩된 사용자 촬영 프레임을 append함
                let ad = UIApplication.shared.delegate as! AppDelegate
                ad.baseUserImage = ad.baseUserImage + baseImage + "엔터" // "엔터"는 각 이미지의 구분을 위함
                // ad.baseUserImage = baseImage
                self.imageCount += 1
            }
            
            if(self.imageCount == 25) {
                self.stateOutlet.text = "완료 버튼을 눌러주세요"
            }
        }

    }
}


