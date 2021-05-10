////
////  ViewController.swift
////  SCTV
////
////  Created by 심찬영 on 2021/05/09.
////
//
//import UIKit
//import CoreBluetooth // 블루투스 사용
//
//class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//    @IBOutlet weak var sendTextField: UITextField!
//
//    @IBAction func sendButton(_ sender: Any) {
//        if let text = sendTextField{
//            writeValue(data: sendTextField.text)
//            }
//    }
//
//    // 상태가 변하면(ex, Bluetooth is turned off) 자동으로 호출되는 콜백 메소드
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
////        if let central = central {
//            if central.state == CBManagerState.poweredOn {
//                // 다양한 로직 구현 가능
//                // 여기에선 최대한 simple하게 작성
//                print("Bluetooth ON")
//            }
//            else {
//                print("Bluetooth switched off or not initialized")
//            }
//        //}
//    }
//
//    // 어떤 데이터든 들어오면 잡아주는 메소드
//    // 여기에선 navigation bar item에 출력해줌
//    // Get data values when they are updated
//    func peripheral(peripheral: CBPeripheral?, didUpdateValueForCharacteristic characteristic: CBCharacteristic?, error: NSError!) {
//        if let characteristicValue = characteristic?.value{
//            var datastring = NSString(data: characteristicValue, encoding: CFStringConvertEncodingToNSStringEncoding(0x0422))
//            if let datastring = datastring {
//                navigationItem.title = datastring as String
//            }
//        }
//    }
//
//    // 데이터를 작성하여 블루투스 디바이스로 전송해주는 메소드
//    // Write function
//    func writeValue(data: String?){
//        let data = (data! as NSString).data(using: CFStringConvertEncodingToNSStringEncoding(0x0422))
//        if let peripheralDevice = peripheralDevice {
//            if let deviceCharacteristics = deviceCharacteristics {
//                peripheralDevice.writeValue(data!, for: deviceCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
//            }
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        if let activeCentralManager = activeCentralManager{
//            activeCentralManager.delegate = self
//        }
//        if let peripheralDevice = peripheralDevice{
//            peripheralDevice.delegate = self
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//}
//
//
//
//

import UIKit
import CoreBluetooth

class BluetoothViewController : UIViewController {
    private var centralManager : CBCentralManager!
    override func viewDidLoad () {
        슈퍼 . viewDidLoad ()
        centralManager = CBCentralManager ( delegate : self , queue : nil )
    }
}
