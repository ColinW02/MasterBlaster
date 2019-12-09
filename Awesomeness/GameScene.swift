//
//  GameScene.swift
//  Awesomeness
//
//  Created by Wunch, Colin R on 12/3/19.
//  Copyright © 2019 Wunch, Colin R. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
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
        let monster = SKSpriteNode (imageNamed: "enemy")
        
        //Pick a direction and SPAWN
        let spawnPos = Int.random(in: 1..<5)
        if spawnPos == 1 {
            monster.position = CGPoint(x: 0 - monster.size.width, y: size.height/16)
        } else if spawnPos == 2 {
            monster.position = CGPoint(x: size.width/16, y: size.height + monster.size.width)
        } else if spawnPos == 3 {
            monster.position = CGPoint(x: size.width + monster.size.width, y: size.height/16)
        } else if spawnPos == 4 {
            monster.position = CGPoint(x: size.width/16, y: -size.height - monster.size.width)
        }
        
        addChild(monster)
        
        let actualDuration = Double.random(in: 2.0..<4.0)
        
        let move = SKAction.move(to: CGPoint(x: size.width/16, y: size.height/16), duration: TimeInterval(actualDuration))
        let moveFinished = SKAction.removeFromParent()
        let loseAction = SKAction.run() { [weak self] in
          guard let `self` = self else { return }
          let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        }
        monster.run(SKAction.sequence([move, loseAction, moveFinished]))
        
    }
    
}
