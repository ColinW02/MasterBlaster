//
//  GameScene.swift
//  Awesomeness
//
//  Created by Wunch, Colin R on 12/3/19.
//  Copyright © 2019 Wunch, Colin R. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background1.jpg")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
    }
}
