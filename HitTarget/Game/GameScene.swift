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
    
    // Узлы
    var backgraundNode = SKSpriteNode(imageNamed: NameImage.bg.rawValue)
    var gunNode = SKSpriteNode(imageNamed: NameImage.gun.rawValue)
    var trajectoryNode = SKSpriteNode(imageNamed: NameImage.trajectory.rawValue)
    var ballNode: SKShapeNode = SKShapeNode(circleOfRadius: 12)
    var winZoneNode = SKSpriteNode(imageNamed: NameImage.winZone.rawValue)

    var arrayTrajectory: [SKSpriteNode] = []
    var cofDistanceTrajectory: CGFloat = 1
    var startTouchForce: CGFloat = 0
    var endTouchForce: CGFloat = 0
    var angleBall: CGFloat = 0
    var isStartMoveBall: Bool = false
    var isFistLevel: Bool = true
    var multilplierScore: Int = 1
    
    var gameVCDelegate: GameViewControllerDelegate?
    
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
                
        view.scene?.delegate = self
        physicsWorld.contactDelegate = self
        
        createGun()
    }
    
    func startGame() {
        for item in someStuff {
            item.removeFromParent()
        }
        someStuff = []
        generateRandomObstacel()
    }
    
    private var someStuff: [SKShapeNode] = []

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
            for node in arrayTrajectory {
                node.removeFromParent()
            }
            arrayTrajectory.removeAll()
            
            ballNode = SKShapeNode(circleOfRadius: 12)
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
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 12)
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.friction = 10
        ball.physicsBody?.linearDamping = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.angularVelocity = 0
        ball.physicsBody?.affectedByGravity = false
        
        ball.physicsBody?.categoryBitMask = UInt32(BodyType.ball)
        ball.physicsBody?.collisionBitMask = UInt32(BodyType.cylinder)
        ball.physicsBody?.contactTestBitMask = UInt32(BodyType.cylinder)
        
        someStuff.append(ball)
        addChild(ball)
    }
    
    //Препятствия
    private func generateRandomObstacel() {
        if isFistLevel == true {
            for position in -2...2 {
                let node = SKShapeNode(circleOfRadius: 7)
                node.fillColor = .white
                node.physicsBody = SKPhysicsBody(circleOfRadius: 7)
                node.physicsBody?.categoryBitMask = UInt32(BodyType.cylinder)
                node.physicsBody?.collisionBitMask = UInt32(BodyType.ball)
                node.physicsBody?.contactTestBitMask = UInt32(BodyType.ball)
                node.physicsBody?.affectedByGravity = false
                node.physicsBody?.isDynamic = false
                
                node.position = CGPoint(x: position * 60, y: -120)
                someStuff.append(node)
                addChild(node)
            }
            for position in -2...1 {
                let node = SKShapeNode(circleOfRadius: 7)
                node.fillColor = .white
                node.physicsBody = SKPhysicsBody(circleOfRadius: 7)
                node.physicsBody?.categoryBitMask = UInt32(BodyType.cylinder)
                node.physicsBody?.collisionBitMask = UInt32(BodyType.ball)
                node.physicsBody?.contactTestBitMask = UInt32(BodyType.ball)
                node.physicsBody?.affectedByGravity = false
                node.physicsBody?.isDynamic = false
                
                node.position = CGPoint(x: (position * 60) + 30, y: -60)
                someStuff.append(node)
                addChild(node)
            }
            
            for position in -1...1 {
                let node = SKShapeNode(circleOfRadius: 7)
                node.fillColor = .white
                node.physicsBody = SKPhysicsBody(circleOfRadius: 7)
                node.physicsBody?.categoryBitMask = UInt32(BodyType.cylinder)
                node.physicsBody?.collisionBitMask = UInt32(BodyType.ball)
                node.physicsBody?.contactTestBitMask = UInt32(BodyType.ball)
                node.physicsBody?.affectedByGravity = false
                node.physicsBody?.isDynamic = false
                
                node.position = CGPoint(x: position * 60, y: 0)
                someStuff.append(node)
                addChild(node)
            }
            for position in -1...0 {
                let node = SKShapeNode(circleOfRadius: 7)
                node.fillColor = .white
                node.physicsBody = SKPhysicsBody(circleOfRadius: 7)
                node.physicsBody?.categoryBitMask = UInt32(BodyType.cylinder)
                node.physicsBody?.collisionBitMask = UInt32(BodyType.ball)
                node.physicsBody?.contactTestBitMask = UInt32(BodyType.ball)
                node.physicsBody?.affectedByGravity = false
                node.physicsBody?.isDynamic = false
                
                node.position = CGPoint(x: (position * 60) + 30, y: 60)
                someStuff.append(node)
                addChild(node)
            }
        } else {
            let random = Int.random(in: 0...20)
            if random != 0 {
                for _ in 1...random {
                    let node = SKShapeNode(circleOfRadius: 7)
                    node.fillColor = .white
                    node.physicsBody = SKPhysicsBody(circleOfRadius: 7)
                    node.physicsBody?.categoryBitMask = UInt32(BodyType.cylinder)
                    node.physicsBody?.collisionBitMask = UInt32(BodyType.ball)
                    node.physicsBody?.contactTestBitMask = UInt32(BodyType.ball)
                    node.physicsBody?.affectedByGravity = false
                    node.physicsBody?.isDynamic = false
                    
                    let randomYPosition = CGFloat.random(in: (frame.minY + 200)...(frame.maxY - 300))
                    let randomXPosition = CGFloat.random(in: (frame.minX + 100)...(frame.maxX - 100))
                    node.position = CGPoint(x: randomXPosition, y: randomYPosition)
                    someStuff.append(node)
                    addChild(node)
                }
            }
        }
    }
    //Умножители
    private func createViewX(position: CGPoint, random: Int) {
        let waitForViewXAction = SKAction.wait(forDuration: 1)

        let xView = SKSpriteNode(color: .red, size: CGSize(width: 25, height: 15))
        xView.position = position
        switch random {
        case 1...30:
            xView.color = #colorLiteral(red: 0.0008286739395, green: 0.6636774934, blue: 0.001285641101, alpha: 1)
        case 31...60:
            xView.color = #colorLiteral(red: 0.9047964994, green: 0.3965190906, blue: 0.04602504304, alpha: 1)
        case 61...100:
            xView.color = #colorLiteral(red: 0.6676237769, green: 0.07868764245, blue: 0.00213138055, alpha: 1)
        case 101...699:
            xView.color = #colorLiteral(red: 0.0008286739395, green: 0.6636774934, blue: 0.001285641101, alpha: 1)
        case 700...899:
            xView.color = #colorLiteral(red: 0.9047964994, green: 0.3965190906, blue: 0.04602504304, alpha: 1)
        case 900...1000:
            xView.color = #colorLiteral(red: 0.6676237769, green: 0.07868764245, blue: 0.00213138055, alpha: 1)
        default:
            xView.color = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        }
        addChild(xView)
        
        let label = SKLabelNode(text: "x\(random)")
        label.fontSize = 7
        label.color = .white
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x: position.x - 1, y: position.y - 2)
        addChild(label)
        
        self.run(waitForViewXAction) {
            label.removeFromParent()
            xView.removeFromParent()
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
                    //Самая близка зона к центру
                    if ballNode.position.y >= winZoneNode.frame.midY - 15 && ballNode.position.y <= winZoneNode.frame.midY + 15 && ballNode.position.x >= winZoneNode.frame.midX - 15 && ballNode.position.x <= winZoneNode.frame.midX + 15 {
                        let random = Int.random(in: 900...1000)
                        GameViewController.endScore = random * multilplierScore
                        createViewX(position: ballNode.position, random: random)
                    } else if ballNode.position.y >= winZoneNode.frame.midY - 30 && ballNode.position.y <= winZoneNode.frame.midY + 30 && ballNode.position.x >= winZoneNode.frame.midX - 30 && ballNode.position.x <= winZoneNode.frame.midX + 30 {
                        let random = Int.random(in: 700...899)
                        GameViewController.endScore = random * multilplierScore
                        createViewX(position: ballNode.position, random: random)
                    } else {
                        let random = Int.random(in: 101...699)
                        createViewX(position: ballNode.position, random: random)
                        GameViewController.endScore = random * multilplierScore
                    }

                    GameViewController.isWin = true
                    isFistLevel = false
                    let waitForViewXAction = SKAction.wait(forDuration: 1)

                    self.run(waitForViewXAction) { [weak self] in
                        self?.gameVCDelegate?.showWinScreen()
                    }
                } else {
                    GameViewController.isWin = false
                    gameVCDelegate?.showWinScreen()
                }
                isStartMoveBall = false
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactPoint = contact.contactPoint
            
        //Переменные контакта
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        let ball = UInt32(BodyType.ball)
        let cylinder = UInt32(BodyType.cylinder)
        
        if bodyA == ball && bodyB == cylinder || bodyB == ball && bodyA == cylinder {
            let random = Int.random(in: 1...100)
            multilplierScore = multilplierScore + random
            createViewX(position: contactPoint, random: random)
        }
    }
}
