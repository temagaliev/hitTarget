//
//  GameViewController.swift
//  HitTarget
//
//  Created by Artem Galiev on 22.09.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: view.frame)
        view.addSubview(skView)
        
        let skScene = SKScene(fileNamed: "GameScene")
        skScene?.scaleMode = .fill
        skView.presentScene(skScene)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { [weak self] in
//            self?.dismiss(animated: true)
//        })
    }
    
    
}
