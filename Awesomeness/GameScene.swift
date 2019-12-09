//
//  GameScene.swift
//  Awesomeness
//
//  Created by Wunch, Colin R on 12/3/19.
//  Copyright © 2019 Wunch, Colin R. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private var bird = SKSpriteNode()
    private var birdFlyFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addEnemy),
            SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
