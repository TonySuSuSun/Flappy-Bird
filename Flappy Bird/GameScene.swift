//
//  GameScene.swift
//  Flappy Bird
//
//  Created by 蘇炫瑋 on 2025/4/12.
//

import GameplayKit
import SpriteKit
import SwiftUI

class GameScene: SKScene {
    
    var ground:SKSpriteNode!
    var title:SKLabelNode!
    var startButton:SKLabelNode!
    var scoreButton:SKLabelNode!

    var isGameStart = false
    
    func createGround() {
        let ground = SKSpriteNode(imageNamed: "ground.png")
        ground.size = CGSize(width: 1536, height: 768)
        ground.position = CGPoint(x: 512, y: 384)
        ground.zPosition = 0
        ground.name = "ground"
        addChild(ground)
    }
    
    func createTitle(){
        let title = SKLabelNode(fontNamed: "Impact")
        title.text = "Flappy Bird"
        title.fontColor = UIColor.black
        title.horizontalAlignmentMode = .center
        title.fontSize = 108
        title.position = CGPoint(x: 384, y: 768)
        title.zPosition = 1
        addChild(title)
    }
    
    func createStartButton(){
        let startButton = SKLabelNode(fontNamed: "Impact")
        startButton.text = "Start"
        startButton.fontColor = UIColor.black
        startButton.horizontalAlignmentMode = .center
        startButton.fontSize = 72
        startButton.position = CGPoint(x: 384, y: 512)
        startButton.zPosition = 1
        addChild(startButton)
    }
    
    func createScoreButton(){
        let scoreButton = SKLabelNode(fontNamed: "Impact")
        scoreButton.text = "Score"
        scoreButton.fontColor = UIColor.black
        scoreButton.horizontalAlignmentMode = .center
        scoreButton.fontSize = 72
        scoreButton.position = CGPoint(x: 384, y: 372)
        scoreButton.zPosition = 1
        addChild(scoreButton)
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x:0, y:0)
        let sky = SKSpriteNode(imageNamed: "sky.png")
        sky.size = CGSize(width: 2048, height: 1024)
        sky.position = CGPoint(x: 512, y: 512)
        sky.blendMode = .replace
        sky.zPosition = -1
        addChild(sky)
        
        createGround()
        createTitle()
        createStartButton()
        createScoreButton()
    }

    func touchDown(atPoint pos: CGPoint) {

    }

    func touchMoved(toPoint pos: CGPoint) {

    }

    func touchUp(atPoint pos: CGPoint) {

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func update(_ currentTime: TimeInterval) {

    }
}

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: 768, height: 1024))
        scene.scaleMode = .aspectFit
        return scene
    }
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview(traits: .landscapeRight) {
    GameView()
}
