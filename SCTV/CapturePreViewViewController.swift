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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoCapture.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.videoCapture.initCamera(){
            (self.previewView.layer as! AVCaptureVideoPreviewLayer).session =
                self.videoCapture.captureSession
            
            (self.previewView.layer as! AVCaptureVideoPreviewLayer).videoGravity =
                AVLayerVideoGravity.resizeAspectFill
            
            self.videoCapture.asyncStartCapturing()
        }else{
            fatalError("Fail to init Video Capture")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.videoCapture.asyncStopCapturing()
    }
    
    @IBOutlet var previewView: UIView!
    
    @IBAction func btnDone(_ sender: Any) {
        let ad = UIApplication.shared.delegate as? AppDelegate
        print(ad!.baseUserImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        while(true) {
            
            
            
            let param: [String: String] = [
                "name": self.storyboard?.instantiateViewController(withIdentifier: <#T##String#>).tfName.text!,
                "content": "empty",
                "image": baseImage!
            ]

            AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
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
    }
     */
}


// MARK: - VideoCaptureDelegate
extension CapturePreViewViewController: VideoCaptureDelegate{
    
    func onFrameCaptured(videoCapture: VideoCapture,pixelBuffer:CVPixelBuffer?,timestamp:CMTime){
        
        guard let pixelBuffer = pixelBuffer else{ return }
        
        // 모델 학습용 사진 준비
        // print("\n\n\n")
        let uiImage = UIImage(ciImage: CIImage(cvImageBuffer: pixelBuffer).resize(size: CGSize(width: 200, height: 200)))
        let baseImage = uiImage.jpegData(compressionQuality: 0.1)!.base64EncodedString()
        // print(baseImage)
        // print("\n\n\n")
        
        DispatchQueue.main.async {
            // AppDelegate의 baseUserImage에 base64로 인코딩된 사용자 촬영 프레임을 append함
            let ad = UIApplication.shared.delegate as! AppDelegate
            ad.baseUserImage = ad.baseUserImage + baseImage + "\n"
            print("here")
        }
    }
}


