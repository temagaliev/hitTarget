//
//  MenuViewController.swift
//  HitTarget
//
//  Created by Artem Galiev on 22.09.2023.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playAction(_ sender: Any) {
        
    }
    
    @IBAction func privacyPolicyAction(_ sender: Any) {
        let vc = PrivacyPolicyViewController()
        present(vc, animated: true)
    }
    
}