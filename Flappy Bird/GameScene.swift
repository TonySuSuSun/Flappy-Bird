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
    
    var ceiling:SKSpriteNode!
    var ground:SKSpriteNode!
    var bird:SKSpriteNode!
    
    var birdTextureAtlas = SKTextureAtlas()
    var birdTextureArray = [SKTexture]()
    
    var title:SKLabelNode!
    var startButton:SKLabelNode!
    var scoreButton:SKLabelNode!

    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "\(score)"
        }
    }
    
    var isGameStart = false
    
    func createCeiling(){
        ceiling = SKSpriteNode()
        ceiling.size = CGSize(width: 1534, height: 104)
        ceiling.position = CGPoint(x: 384, y: 1140)
        ceiling.zPosition = 0
        ceiling.name = "ceiling"
        addChild(ceiling)
        
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1534, height: 104))
        ceiling.physicsBody?.affectedByGravity = false
    }
    
    func createGround() {
        ground = SKSpriteNode(imageNamed: "ground.png")
        ground.size = CGSize(width: 1534, height: 104)
        ground.position = CGPoint(x: 384, y: 52)
        ground.zPosition = 0
        ground.name = "ground"
        addChild(ground)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1534, height: 104))
        ground.physicsBody?.affectedByGravity = false
    }
    
    func createTitle(){
        title = SKLabelNode(fontNamed: "Impact")
        title.text = "Flappy Bird"
        title.fontColor = UIColor.black
        title.horizontalAlignmentMode = .center
        title.fontSize = 108
        title.position = CGPoint(x: 384, y: 768)
        title.zPosition = 1
        addChild(title)
    }
    
    func createStartButton(){
        startButton = SKLabelNode(fontNamed: "Impact")
        startButton.text = "Start"
        startButton.fontColor = UIColor.black
        startButton.horizontalAlignmentMode = .center
        startButton.fontSize = 72
        startButton.position = CGPoint(x: 384, y: 512)
        startButton.zPosition = 1
        startButton.name = "Start"
        addChild(startButton)
    }
    
    func createScoreButton(){
        scoreButton = SKLabelNode(fontNamed: "Impact")
        scoreButton.text = "Score"
        scoreButton.fontColor = UIColor.black
        scoreButton.horizontalAlignmentMode = .center
        scoreButton.fontSize = 72
        scoreButton.position = CGPoint(x: 384, y: 372)
        scoreButton.zPosition = 1
        scoreButton.name = "Score"
        addChild(scoreButton)
    }
    
    func createScore(){
        gameScore = SKLabelNode(fontNamed: "Impact")
        gameScore.fontColor = UIColor.black
        gameScore.horizontalAlignmentMode = .center
        gameScore.fontSize = 72
        gameScore.position = CGPoint(x: 384, y: 896)
        gameScore.zPosition = 1
        addChild(gameScore)
        score = 0
    }
    
    func createBird(){
        birdTextureAtlas = SKTextureAtlas(named: "bird")
        for i in 1...birdTextureAtlas.textureNames.count{
            var name = "bird-\(i)"
            birdTextureArray.append(SKTexture(imageNamed: name))
        }
        
        bird = SKSpriteNode(imageNamed: birdTextureAtlas.textureNames[0])
        bird.size = CGSize(width: 105, height: 90.75)
        bird.position = CGPoint(x: 336, y: 512)
        bird.zPosition = 0
        bird.name = "bird"
        addChild(bird)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 105, height: 90.75))
        ground.physicsBody?.affectedByGravity = false
        
        // bird.run(SKAction.repeatForever(SKAction.animate(withNormalTextures: birdTextureArray, timePerFrame: 0.2)))
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x:0, y:0)
        let sky = SKSpriteNode(imageNamed: "sky.png")
        sky.size = CGSize(width: 2048, height: 1024)
        sky.position = CGPoint(x: 512, y: 512)
        sky.blendMode = .replace
        sky.zPosition = -1
        addChild(sky)
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        createCeiling()
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
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        for case let node as SKSpriteNode in nodesAtPoint {
            if node.name == "Start" {
                
            } else if node.name == "Score" {
                
            } else if node.name == "OK" {
                
            } else if node.name == "Pause" {
                
            } else {
                
            }
        }
        
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
