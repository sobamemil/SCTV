//
//  LanchScreenViewController.swift
//  SCTV
//
//  Created by 심찬영 on 2021/06/01.
//
// lanchscreen viewcontroller

import UIKit

class LanchScreenViewController: UIViewController {
    
    @IBOutlet weak var imgLanch: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgLanch.image = UIImage(named: "cctv.png")
        
    }
}
