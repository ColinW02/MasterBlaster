//
//  GameScene.swift
//  Awesomeness
//
//  Created by Wunch, Colin R on 12/3/19.
//  Copyright © 2019 Wunch, Colin R. All rights reserved.
//

import SpriteKit
import GameplayKit

private var bird = SKSpriteNode()
private var birdFlyFrames: [SKTexture] = []

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
    
    override func didMove(to view: SKView) {
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addEnemy),
            SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(player)
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
        let touchPosition = touch.location(in: self)
        //Need player to test v
        //projectile.position = player.position
        let projectile = SKSpriteNode(imageNamed: "PlaceholderProjectile")
        projectile.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
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
        let duolingoAtlas = SKTextureAtlas(named: "EvilDuolingoBird")
        var flyingFrames: [SKTexture] = []
        
        let numImages = duolingoAtlas.textureNames.count
        for i in 0...numImages-1 {
            let birdName = "sprite\(i)"
        flyingFrames.append(duolingoAtlas.textureNamed(birdName))
        }
        birdFlyFrames = flyingFrames
        
        let firstFrameTexture = birdFlyFrames[0]
        bird = SKSpriteNode(texture: firstFrameTexture)
        
        //Pick a direction and SPAWN
        let spawnPos = Int.random(in: 1..<5)
        if spawnPos == 1 {
            bird.position = CGPoint(x: 0 - bird.size.width, y: size.height/16)
        } else if spawnPos == 2 {
            bird.position = CGPoint(x: size.width/16, y: size.height + bird.size.width)
        } else if spawnPos == 3 {
            bird.position = CGPoint(x: size.width + bird.size.width, y: size.height/16)
        } else if spawnPos == 4 {
            bird.position = CGPoint(x: size.width/16, y: -size.height - bird.size.width)
        }
        
        addChild(bird)
        
        let actualDuration = Double.random(in: 2.0..<4.0)
        
        bird.run(SKAction.repeatForever(SKAction.animate(with: birdFlyFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey: "fly")
        
        let move = SKAction.move(to: CGPoint(x: size.width/16, y: size.height/16), duration: TimeInterval(actualDuration))
        let moveFinished = SKAction.removeFromParent()
        let loseAction = SKAction.run() { [weak self] in
          guard let `self` = self else { return }
          let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        }
        bird.run(SKAction.sequence([move, loseAction, moveFinished]))
    }
    
    }
    

