import SpriteKit

class gameoverlmao: SKScene {
    init(size: CGSize, won:Bool) {
        super.init(size: size)

        backgroundColor = SKColor.white
        let message = won ? "dub" : "lmao fat L"
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run() { [weak self] in
                guard let `self` = self else { return }
                let reveal = SKTransition.doorway(withDuration: 2.0)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
