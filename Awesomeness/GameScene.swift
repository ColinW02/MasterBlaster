//
//  GameScene.swift
//  Awesomeness
//
//  Created by Wunch, Colin R on 12/3/19.
//  Copyright © 2019 Wunch, Colin R. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let monster   : UInt32 = 0b1       // 1
    static let projectile: UInt32 = 0b10      // 2
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    let player = SKSpriteNode(imageNamed: "Player")
    var monstersSlaughtered = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(player)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addEnemy),
            SKAction.wait(forDuration: 1.0)
            ])
        ))
        let backgroundMusic = SKAudioNode(fileNamed: "Music")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    func addEnemy(){
        let monster = SKSpriteNode (imageNamed: "enemy")
        
        //Pick a direction and SPAWN
        let spawnPos = Int.random(in: 1..<5)
        if spawnPos == 1 {
            monster.position = CGPoint(x: 0 - monster.size.width, y: size.height/2)
        } else if spawnPos == 2 {
            monster.position = CGPoint(x: size.width/2, y: size.height + monster.size.width)
        } else if spawnPos == 3 {
            monster.position = CGPoint(x: size.width + monster.size.width, y: size.height/2)
        } else if spawnPos == 4 {
            monster.position = CGPoint(x: size.width/2, y: -size.height - monster.size.width)
        }
        
        addChild(monster)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monster
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualDuration = Double.random(in: 2.0..<4.0)
        
        let move = SKAction.move(to: CGPoint(x: size.width/2, y: size.height/2), duration: TimeInterval(actualDuration))
        let moveFinished = SKAction.removeFromParent()
        let loseAction = SKAction.run() { [weak self] in
        guard let `self` = self else { return }
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = gameoverlmao(size: self.size, won: false)
        self.view?.presentScene(gameOverScene, transition: reveal)
        }
        monster.run(SKAction.sequence([move, loseAction, moveFinished]))
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
            guard let touch = touches.first else {
                return
            }
            //run(SKAction.playSoundFileNamed("", waitForCompletion: false))
            let touchPosition = touch.location(in: self)
            let projectile = SKSpriteNode(imageNamed: "PlaceholderProjectile")
            projectile.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            let offset = touchPosition - projectile.position
            addChild(projectile)
            let direction = offset.normalized()
            let shootAmount = direction * 1000
            let realDest = shootAmount + projectile.position
            let actionMove = SKAction.move(to: realDest, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        }
    }
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
        monstersSlaughtered += 1
        if monstersSlaughtered > 3 {
            let reveal = SKTransition.doorsOpenVertical(withDuration: 3.0)
            let gameOverScene = gameoverlmao(size: self.size, won: true)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode,
                let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
    }
}
