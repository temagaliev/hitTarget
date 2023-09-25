//
//  WinViewController.swift
//  HitTarget
//
//  Created by Artem Galiev on 22.09.2023.
//

import UIKit

class WinViewController: UIViewController {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var imageStatus: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GameViewController.isWin == true {
            bgImage.image = UIImage(named: NameImage.winBg.rawValue)
            imageStatus.image = UIImage(named: NameImage.win.rawValue)
        } else {
            bgImage.image = UIImage(named: NameImage.loserBg.rawValue)
            imageStatus.image = UIImage(named: NameImage.loser.rawValue)
        }
    }
    @IBAction func replayAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.gameEnd.rawValue), object: nil)
    }
}
