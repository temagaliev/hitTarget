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
    
    static var isWin: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(winerOrLoserAction), name: NSNotification.Name(rawValue: NotificationName.gameEnd.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeAction), name: NSNotification.Name(rawValue: NotificationName.closeGame.rawValue), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let skView = SKView(frame: view.frame)
        view.addSubview(skView)
        
        
        let skScene = SKScene(fileNamed: "GameScene")
        skScene?.size = CGSize(width: view.frame.width, height: view.frame.height)
        skScene?.scaleMode = .aspectFill
        skView.presentScene(skScene)
    }
    
    @objc func winerOrLoserAction() {
        let vc = WinViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated:  true)
    }
    
    @objc func closeAction() {
        dismiss(animated: true)
    }
    
    
}
