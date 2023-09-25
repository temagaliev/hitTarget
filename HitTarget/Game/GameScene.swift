//
//  GameScene.swift
//  HitTarget
//
//  Created by Artem Galiev on 22.09.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var backgraundNode = SKSpriteNode(imageNamed: NameImage.bg.rawValue)
    var ballNode = SKSpriteNode(imageNamed: NameImage.ball.rawValue)
    
    var topBorder = SKSpriteNode()
    var bottomBorder = SKSpriteNode()
    var leftBorder = SKSpriteNode()
    var rightBorder = SKSpriteNode()

    
    
    override func didMove(to view: SKView) {
        backgraundNode.position = CGPoint(x: 0, y: 0)
        backgraundNode.size = CGSize(width: frame.width, height: frame.height)
        addChild(backgraundNode)
    }
    
    private func createBorder() {
        topBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 1))
        topBorder.physicsBody?.affectedByGravity = false
        topBorder.physicsBody?.isDynamic = false
        topBorder.position = .init(x: 0, y: frame.height / 2)
        addChild(topBorder)
        
        bottomBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 1))
        bottomBorder.physicsBody?.affectedByGravity = false
        bottomBorder.physicsBody?.isDynamic = false
        bottomBorder.position = .init(x: 0, y: -frame.height / 2)
        addChild(bottomBorder)
        
        leftBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: frame.height))
        leftBorder.physicsBody?.affectedByGravity = false
        leftBorder.physicsBody?.isDynamic = false
        leftBorder.position = .init(x: -frame.width / 2, y: 0)
        addChild(leftBorder)
        
        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: frame.height))
        rightBorder.physicsBody?.affectedByGravity = false
        rightBorder.physicsBody?.isDynamic = false
        rightBorder.position = .init(x: frame.width, y: 0)
        addChild(rightBorder)
    }

}
