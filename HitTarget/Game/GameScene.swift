//
//  GameScene.swift
//  HitTarget
//
//  Created by Artem Galiev on 22.09.2023.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    var backgraundNode = SKSpriteNode(imageNamed: NameImage.bg.rawValue)
    var gunNode = SKSpriteNode(imageNamed: NameImage.gun.rawValue)
    var trajectoryNode = SKSpriteNode(imageNamed: NameImage.trajectory.rawValue)
    var ballNode = SKShapeNode(circleOfRadius: 15)
    var winZoneNode = SKSpriteNode(imageNamed: NameImage.winZone.rawValue)

    var arrayTrajectory: [SKSpriteNode] = []
    var cofDistanceTrajectory: CGFloat = 1
    var startTouchForce: CGFloat = 0
    var endTouchForce: CGFloat = 0
    var angleBall: CGFloat = 0
    var isStartMoveBall: Bool = false

    
    override func didMove(to view: SKView) {
        backgraundNode.position = CGPoint(x: 0, y: 0)
        backgraundNode.size = CGSize(width: frame.width, height: frame.height)
        addChild(backgraundNode)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.angularDamping = 0
        
        winZoneNode.position = CGPoint(x: 0, y: frame.maxY - 200)
        winZoneNode.size = CGSize(width: 100, height: 100)
        addChild(winZoneNode)

        createGun()
        generateRandomObstacel()
        
        view.scene?.delegate = self
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isStartMoveBall == false {
            if let touch = touches.first {
                let location = touch.location(in: self)
                startTouchForce = location.y
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isStartMoveBall == false {

            arrayTrajectory.removeAll()
            createBall(ball: ballNode)

            ballNode.physicsBody?.applyForce(CGVector(dx: sin(angleBall) * -3000 * cofDistanceTrajectory, dy: cos(angleBall) * 3000 * cofDistanceTrajectory))
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { [weak self] in
                self?.isStartMoveBall = true
            })
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isStartMoveBall == false {
            for node in arrayTrajectory {
                node.removeFromParent()
            }
            
            arrayTrajectory.removeAll()
            
            if let touch = touches.first {
                let location = touch.location(in: self)
                let dx = location.x - gunNode.position.x
                let dy = location.y - gunNode.position.y
                let angle = atan2(-dx, dy)
                gunNode.zRotation = angle
                angleBall = angle
                
                if location.y < startTouchForce {
                    cofDistanceTrajectory = abs((startTouchForce - location.y) / startTouchForce)
                    if cofDistanceTrajectory > 2 {
                        cofDistanceTrajectory = 2
                    }
                    for i in 0...5 {
                        let trajectoryNode = SKSpriteNode(imageNamed: NameImage.trajectory.rawValue)
                        trajectoryNode.size = CGSize(width: 10, height: 10)
                        trajectoryNode.position.x = 0
                        trajectoryNode.position.y =  100 + CGFloat(i) * 30 * cofDistanceTrajectory
                        gunNode.addChild(trajectoryNode)
                        arrayTrajectory.append(trajectoryNode)
                    }
                }
            }
        }
    }
    
    //MARK: - Создание элементов
    //Пушка
    private func createGun() {
        gunNode.position = CGPoint(x: 0, y: frame.minY + 100)
        gunNode.size = CGSize(width: 60, height: 80)
        addChild(gunNode)
    }
    
    //Шарик
    private func createBall(ball: SKShapeNode) {
        ball.position = CGPoint(x: 0, y: frame.minY + 90)
        ball.physicsBody?.mass = 0.5
        ball.fillColor = .yellow
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.friction = 10
        ball.physicsBody?.linearDamping = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.angularVelocity = 0
        ball.physicsBody?.affectedByGravity = false
        addChild(ball)
    }
    
    //Препятствия
    private func generateRandomObstacel() {
        let random = Int.random(in: 0...5)
        if random != 0 {
            for _ in 1...random {
                let radius = CGFloat.random(in: 20...50)
                let node = SKShapeNode(circleOfRadius: radius)
                node.fillColor = .white
                node.physicsBody = SKPhysicsBody(circleOfRadius: radius)
                node.physicsBody?.affectedByGravity = false
                node.physicsBody?.isDynamic = false
                
                let randomYPosition = CGFloat.random(in: (frame.minY + 200)...(frame.maxY - 300))
                let randomXPosition = CGFloat.random(in: (frame.minX + 100)...(frame.maxX - 100))
                node.position = CGPoint(x: randomXPosition, y: randomYPosition)
                addChild(node)
            }
        }
    }

}

//MARK: - SKSceneDelegate
extension GameScene: SKSceneDelegate {
    override func update(_ currentTime: TimeInterval) {
        //Проверка на остановку шарика
        if let velocityY = ballNode.physicsBody?.velocity {
            if velocityY.dy < 0.1 && velocityY.dx < 0.1 && velocityY.dy > -0.1 && velocityY.dx > -0.1 && isStartMoveBall == true{
                print(velocityY.dy ," ",  velocityY.dx)
                //Проверка находится ли в выигрышной позиции шарик
                if ballNode.position.y >= winZoneNode.frame.minY && ballNode.position.y <= winZoneNode.frame.maxY && ballNode.position.x >= winZoneNode.frame.minX && ballNode.position.x <= winZoneNode.frame.maxX {
                    GameViewController.isWin = true
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.gameEnd.rawValue), object: nil)
                } else {
                    GameViewController.isWin = false
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.gameEnd.rawValue), object: nil)
                }
                isStartMoveBall = false
            }
        }
    }
}
