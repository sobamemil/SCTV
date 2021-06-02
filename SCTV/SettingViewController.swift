//
//  SettingViewController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/06/02.
//

import UIKit

class SettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CCTVIpAddress.delegate = self
        self.reportNumber.delegate = self
        self.userAddress.delegate = self
    }
    
    @IBOutlet weak var CCTVIpAddress: UITextField!
    @IBOutlet weak var reportNumber: UITextField!
    @IBOutlet weak var userAddress: UITextField!

    @IBAction func btnDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ad = UIApplication.shared.delegate as? AppDelegate
        self.CCTVIpAddress.text = ad?.CCTVipAddress
        self.reportNumber.text = ad?.reportNumber
        self.userAddress.text = ad?.userAddress
    }
}

extension SettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let ad = UIApplication.shared.delegate as? AppDelegate
        if textField == self.CCTVIpAddress {
            ad?.CCTVipAddress = textField.text ?? "empty"
        } else if textField == self.reportNumber {
            ad?.reportNumber = textField.text ?? "empty"
        } else if textField == self.userAddress {
            ad?.userAddress = textField.text ?? "empty"
        }
    }
}
