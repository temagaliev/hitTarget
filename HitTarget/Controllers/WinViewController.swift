//
//  WinViewController.swift
//  HitTarget
//
//  Created by Artem Galiev on 22.09.2023.
//

import UIKit

class WinViewController: UIViewController {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var imageStatus: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GameViewController.isWin == true {
            bgImage.image = UIImage(named: NameImage.winBg.rawValue)
            imageStatus.image = UIImage(named: NameImage.win.rawValue)
            scoreLabel.text = "Score: " + String(GameViewController.endScore)
        } else {
            bgImage.image = UIImage(named: NameImage.loserBg.rawValue)
            imageStatus.image = UIImage(named: NameImage.loser.rawValue)
            scoreLabel.text = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            GameViewController.endScore = 0
            self?.dismiss(animated: true)
        }
    }
}
