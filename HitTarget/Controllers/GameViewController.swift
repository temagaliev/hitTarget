//
//  GameViewController.swift
//  HitTarget
//
//  Created by Artem Galiev on 22.09.2023.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameViewControllerDelegate {
    func showWinScreen()
}

extension GameViewController: GameViewControllerDelegate {
    func showWinScreen() {
        let vc = WinViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated:  true)
    }
    
    
}

class GameViewController: UIViewController {
    
    static var isWin: Bool = false
    static var endScore: Int = 0

    
    let buttonMenu: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: NameImage.menu.rawValue), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skScene: GameScene = SKScene(fileNamed: "GameScene") as! GameScene

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonMenu.addTarget(self, action: #selector(actionButtonMenu), for: .touchUpInside)
        
        let skView = SKView(frame: view.frame)
        view.addSubview(skView)
        
        skScene.size = CGSize(width: view.frame.width, height: view.frame.height)
        skScene.scaleMode = .aspectFill
        skScene.gameVCDelegate = self
        skView.presentScene(skScene)
            
        view.addSubview(buttonMenu)
        buttonMenu.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonMenu.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonMenu.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        buttonMenu.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        skScene.startGame()
    }
    
    @objc func actionButtonMenu() {
        dismiss(animated: true)
    }


    
}
