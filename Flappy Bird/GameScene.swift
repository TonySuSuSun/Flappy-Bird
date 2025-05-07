//
//  GameScene.swift
//  Flappy Bird
//
//  Created by 蘇炫瑋 on 2025/4/12.
//

import GameplayKit
import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {

    var ceiling: SKSpriteNode!  // 天花板(隱形的)
    var ground: SKSpriteNode!  // 地板
    var bird: SKSpriteNode!  // 鳥

    // 鳥的動畫素材
    var birdTextureAtlas = SKTextureAtlas()
    var birdTextureArray = [SKTexture]()

    var title: SKLabelNode!  // 遊戲標題(Flappy Bird)
    var startButton: SKLabelNode!  // 開始按鈕(進入遊戲)
    var scoreButton: SKLabelNode!  // 計分板按鈕(用於看分數紀錄)

    var hintTitle: SKLabelNode!  // 提示點擊開始遊戲的字(Tab to Start!)
    var pauseButton: SKLabelNode!  // 暫停按鈕

    var gameOverTitle: SKLabelNode! // 顯示遊戲結束(Game Over!)
    var showScore: SKLabelNode!  // 遊戲結束時顯示分數
    var restartButton: SKLabelNode!  // 重新開始遊戲的按鈕
    var backButton: SKLabelNode!  // 返回主頁面的按鈕

    // 遊玩分數
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "\(score)"
        }
    }

    var isGameStarted = false  // 檢查遊戲是否已經開始
    var isInGame = false  // 檢查是否在遊戲內
    var isGamePaused = false  // 檢查是否暫停

    func collisionBetween (bird: SKNode, object: SKNode) {
        if object.name == "ground" {
            isInGame = false
            
            gameScore.isHidden = true
            pauseButton.isHidden = true
            pauseButton.isPaused = true
            
            showScore.text = "Final Score:\(score)"
            
            gameOverTitle.isHidden = false
            showScore.isHidden = false
            restartButton.isHidden = false
            restartButton.isPaused = false
            backButton.isHidden = false
            backButton.isPaused = false
        }
    }
    
    func createCeiling() {
        ceiling = SKSpriteNode()
        ceiling.size = CGSize(width: 1534, height: 104)
        ceiling.position = CGPoint(x: 384, y: 1280)
        ceiling.zPosition = 0
        addChild(ceiling)
        ceiling.name = "ceiling"

        ceiling.physicsBody = SKPhysicsBody(
            rectangleOf: ceiling.size)
        ceiling.physicsBody?.isDynamic = false
    }

    func createGround() {
        ground = SKSpriteNode(imageNamed: "ground.png")
        ground.size = CGSize(width: 1534, height: 104)
        ground.position = CGPoint(x: 384, y: 52)
        ground.zPosition = 0
        addChild(ground)
        ground.name = "ground"

        ground.physicsBody = SKPhysicsBody(
            rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
    }

    func createTitle() {
        title = SKLabelNode(fontNamed: "Impact")
        title.text = "Flappy Bird"
        title.fontColor = UIColor.black
        title.horizontalAlignmentMode = .center
        title.fontSize = 108
        title.position = CGPoint(x: 384, y: 768)
        title.zPosition = 1
        addChild(title)
    }

    func createStartButton() {
        startButton = SKLabelNode(fontNamed: "Impact")
        startButton.text = "Start"
        startButton.fontColor = UIColor.black
        startButton.horizontalAlignmentMode = .center
        startButton.fontSize = 72
        startButton.position = CGPoint(x: 384, y: 512)
        startButton.zPosition = 1
        addChild(startButton)
        startButton.name = "Start"
    }

    func createScoreButton() {
        scoreButton = SKLabelNode(fontNamed: "Impact")
        scoreButton.text = "Score"
        scoreButton.fontColor = UIColor.black
        scoreButton.horizontalAlignmentMode = .center
        scoreButton.fontSize = 72
        scoreButton.position = CGPoint(x: 384, y: 372)
        scoreButton.zPosition = 1
        addChild(scoreButton)
        scoreButton.name = "Score"
    }

    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Impact")
        gameScore.fontColor = UIColor.black
        gameScore.horizontalAlignmentMode = .center
        gameScore.fontSize = 72
        gameScore.position = CGPoint(x: 384, y: 896)
        gameScore.zPosition = 1
        addChild(gameScore)
        score = 0
    }

    func createBird() {
        birdTextureAtlas = SKTextureAtlas(named: "bird")
        for i in 1...birdTextureAtlas.textureNames.count {
            let name = "bird-\(i).png"
            birdTextureArray.append(SKTexture(imageNamed: name))
        }

        bird = SKSpriteNode(imageNamed: birdTextureAtlas.textureNames[1])
        bird.size = CGSize(width: 105, height: 90.75)
        bird.position = CGPoint(x: 336, y: 512)
        bird.zPosition = 0
        addChild(bird)
        bird.name = "bird"

        bird.physicsBody = SKPhysicsBody(
            rectangleOf: bird.size)
        bird.physicsBody?.isDynamic = false
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.contactTestBitMask = bird.physicsBody?.collisionBitMask ?? UInt32.max

        bird.run(SKAction.repeatForever(SKAction.animate(withNormalTextures: birdTextureArray, timePerFrame: 0.1)))
    }

    func createHintTitle() {
        hintTitle = SKLabelNode(fontNamed: "Impact")
        hintTitle.text = "Tab to Start!"
        hintTitle.fontColor = UIColor.black
        hintTitle.horizontalAlignmentMode = .center
        hintTitle.fontSize = 72
        hintTitle.position = CGPoint(x: 384, y: 768)
        hintTitle.zPosition = 1
        addChild(hintTitle)
    }

    func createPauseButton() {
        pauseButton = SKLabelNode(fontNamed: "Impact")
        pauseButton.text = "⏸︎"
        pauseButton.fontColor = UIColor.black
        pauseButton.horizontalAlignmentMode = .center
        pauseButton.fontSize = 72
        pauseButton.position = CGPoint(x: 36, y: 960)
        pauseButton.zPosition = 1
        addChild(pauseButton)
        pauseButton.name = "Pause"
    }
    
    func createGameOverTitle() {
        gameOverTitle = SKLabelNode(fontNamed: "Impact")
        gameOverTitle.text = "Game Over!"
        gameOverTitle.fontColor = UIColor.black
        gameOverTitle.horizontalAlignmentMode = .center
        gameOverTitle.fontSize = 108
        gameOverTitle.position = CGPoint(x: 384, y: 832)
        gameOverTitle.zPosition = 1
        addChild(gameOverTitle)
    }
    
    func createShowScore() {
        showScore = SKLabelNode(fontNamed: "Impact")
        showScore.fontColor = UIColor.black
        showScore.horizontalAlignmentMode = .center
        showScore.fontSize = 72
        showScore.position = CGPoint(x: 384, y: 744)
        showScore.zPosition = 1
        addChild(showScore)
    }
    
    func createRestartButton() {
        restartButton = SKLabelNode(fontNamed: "Impact")
        restartButton.text = "Restart"
        restartButton.fontColor = UIColor.black
        restartButton.horizontalAlignmentMode = .center
        restartButton.fontSize = 72
        restartButton.position = CGPoint(x: 384, y: 512)
        restartButton.zPosition = 1
        addChild(restartButton)
        restartButton.name = "Restart"
    }
    
    func createBackButton() {
        backButton = SKLabelNode(fontNamed: "Impact")
        backButton.text = "Back to Menu"
        backButton.fontColor = UIColor.black
        backButton.horizontalAlignmentMode = .center
        backButton.fontSize = 72
        backButton.position = CGPoint(x: 384, y: 372)
        backButton.zPosition = 1
        addChild(backButton)
        backButton.name = "Back"
    }

    func didBegin (_ contact: SKPhysicsContact ) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "bird" {
            collisionBetween (bird: nodeA, object: nodeB)
        } else if nodeB.name == "bird" {
            collisionBetween (bird: nodeB, object: nodeA)
        }
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        let sky = SKSpriteNode(imageNamed: "sky.png")
        sky.size = CGSize(width: 2048, height: 1024)
        sky.position = CGPoint(x: 512, y: 512)
        sky.blendMode = .replace
        sky.zPosition = -1
        addChild(sky)
        physicsWorld.gravity = CGVector(dx: 0, dy: -4)

        createCeiling()
        createGround()

        createTitle()
        createStartButton()
        createScoreButton()

        createHintTitle()
        hintTitle.isHidden = true
        createScore()
        gameScore.isHidden = true
        createPauseButton()
        pauseButton.isHidden = true
        pauseButton.isPaused = true
        
        createGameOverTitle()
        gameOverTitle.isHidden = true
        createShowScore()
        showScore.isHidden = true
        createRestartButton()
        restartButton.isHidden = true
        restartButton.isPaused = true
        createBackButton()
        backButton.isHidden = true
        backButton.isPaused = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if isInGame == true {
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 240)   // 讓鳥飛
            if isGameStarted == false {
                bird.physicsBody?.isDynamic = true  // 讓鳥可以動
                isGameStarted = true
                hintTitle.isHidden = true
            }
        }

        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        for case let node as SKLabelNode in nodesAtPoint {
            if node.name == "Start" {
                isInGame = true
                
                createBird()

                title.isHidden = true
                startButton.isHidden = true
                startButton.isPaused = true
                scoreButton.isHidden = true
                scoreButton.isPaused = true

                hintTitle.isHidden = false
                gameScore.isHidden = false
                pauseButton.isHidden = false
                pauseButton.isPaused = false

            } else if node.name == "Score" {

            } else if node.name == "Back" {
                isGameStarted = false
                
                bird.removeFromParent()
                
                gameOverTitle.isHidden = true
                showScore.isHidden = true
                restartButton.isHidden = true
                restartButton.isPaused = true
                backButton.isHidden = true
                backButton.isPaused = true
                
                title.isHidden = false
                startButton.isHidden = false
                startButton.isPaused = false
                scoreButton.isHidden = false
                scoreButton.isPaused = false
                
            } else if node.name == "Restart" {
                isInGame = true
                isGameStarted = false
                
                bird.removeFromParent()
                
                gameOverTitle.isHidden = true
                showScore.isHidden = true
                restartButton.isHidden = true
                restartButton.isPaused = true
                backButton.isHidden = true
                backButton.isPaused = true
                
                createBird()
                
                hintTitle.isHidden = false
                gameScore.isHidden = false
                pauseButton.isHidden = false
                pauseButton.isPaused = false
                
            } else if node.name == "Pause" {
                if isGamePaused == false {
                    pauseButton.text = "▸"
                    pauseButton.fontSize = 96
                    isGamePaused = true
                    bird.physicsBody?.isDynamic = false
                } else {
                    pauseButton.text = "⏸︎"
                    pauseButton.fontSize = 72
                    isGamePaused = false
                    if isGameStarted == true {
                        bird.physicsBody?.isDynamic = true
                    }
                }
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {

    }
}

struct GameView: View {
    var scene: SKScene{
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
