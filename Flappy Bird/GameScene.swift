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
    var settingButton: SKLabelNode!  // 設定介面按鈕(用於更改設定)

    var hintTitle: SKLabelNode!  // 提示點擊開始遊戲的字(Tab to Start!)
    var pauseButton: SKLabelNode!  // 暫停按鈕

    var gameOverTitle: SKLabelNode!  // 顯示遊戲結束(Game Over!)
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

    var activePillars = [SKSpriteNode]()
    
    var lastUpdateTime: TimeInterval = 0
    var timeAccumulator: TimeInterval = 0

    var isGameStarted = false  // 檢查遊戲是否已經開始
    var isInGame = false  // 檢查是否在遊戲內
    var isGamePaused = false  // 檢查是否暫停

    func collisionBetween(bird: SKNode, object: SKNode) {
        if object.name == "ground" || object.name == "pillar" {
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

            if activePillars.count > 0 {
                for (_, node) in activePillars.enumerated().reversed() {
                    for child in node.children {
                        child.physicsBody?.isDynamic = false
                    }
                }
            }
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
        ceiling.physicsBody?.categoryBitMask = 0b0010
        ceiling.physicsBody?.collisionBitMask = 0b0001
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
        ground.physicsBody?.categoryBitMask = 0b0010
        ground.physicsBody?.collisionBitMask = 0b0001
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

    func createSettingButton() {
        settingButton = SKLabelNode(fontNamed: "Impact")
        settingButton.text = "Setting"
        settingButton.fontColor = UIColor.black
        settingButton.horizontalAlignmentMode = .center
        settingButton.fontSize = 72
        settingButton.position = CGPoint(x: 384, y: 372)
        settingButton.zPosition = 1
        addChild(settingButton)
        settingButton.name = "Setting"
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
        bird.physicsBody?.mass = 1
        bird.physicsBody?.isDynamic = false
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.contactTestBitMask =
            bird.physicsBody?.collisionBitMask ?? UInt32.max

        bird.physicsBody?.categoryBitMask = 0b0001
        bird.physicsBody?.collisionBitMask = 0b0010

        bird.run(
            SKAction.repeatForever(
                SKAction.animate(
                    withNormalTextures: birdTextureArray, timePerFrame: 0.1)))
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

    func createPillar() {
        let pillar = SKSpriteNode()
        pillar.anchorPoint = CGPoint(x: 0.5, y: 0)
        pillar.position = CGPoint(x: 896, y: 0)
        pillar.zPosition = 0

        let randomHeight = Int.random(in: -20...20)

        let up = SKSpriteNode(imageNamed: "pillar-green")
        up.anchorPoint = CGPoint(x: 0.5, y: 1)
        up.position = CGPoint(x: 0, y: 1228)
        up.zPosition = 0
        up.size = CGSize(width: 143, height: 556 + randomHeight * 10)
        up.name = "pillar"
        up.physicsBody = SKPhysicsBody(rectangleOf: up.size, center: CGPoint(x: 0, y: -up.size.height / 2))
        up.physicsBody?.affectedByGravity = false
        up.physicsBody?.allowsRotation = false
        up.physicsBody?.mass = 1000
        up.physicsBody?.friction = 0.0
        up.physicsBody?.linearDamping = 0.0
        up.physicsBody?.categoryBitMask = 0b0010
        up.physicsBody?.collisionBitMask = 0b0001
        pillar.addChild(up)

        let down = SKSpriteNode(imageNamed: "pillar-green")
        down.anchorPoint = CGPoint(x: 0.5, y: 0)
        down.position = CGPoint(x: 0, y: 104)
        down.zPosition = 0
        down.size = CGSize(width: 143, height: 352 - randomHeight * 10)
        down.name = "pillar"
        down.physicsBody = SKPhysicsBody(rectangleOf: down.size, center: CGPoint(x: 0, y: down.size.height / 2))
        down.physicsBody?.affectedByGravity = false
        down.physicsBody?.allowsRotation = false
        down.physicsBody?.mass = 1000
        down.physicsBody?.friction = 0.0
        down.physicsBody?.linearDamping = 0.0
        down.physicsBody?.categoryBitMask = 0b0010
        down.physicsBody?.collisionBitMask = 0b0001
        pillar.addChild(down)

        up.physicsBody?.velocity = CGVector(dx: -120, dy: 0)
        down.physicsBody?.velocity = CGVector(dx: -120, dy: 0)

        addChild(pillar)
        activePillars.append(pillar)

    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "bird" {
            collisionBetween(bird: nodeA, object: nodeB)
        } else if nodeB.name == "bird" {
            collisionBetween(bird: nodeB, object: nodeA)
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
        createSettingButton()

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
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 240)  // 讓鳥飛
            if isGameStarted == false {
                bird.physicsBody?.isDynamic = true  // 讓鳥可以動
                isGameStarted = true
                hintTitle.isHidden = true
                pauseButton.isHidden = false
                pauseButton.isPaused = false
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
                settingButton.isHidden = true
                settingButton.isPaused = true

                hintTitle.isHidden = false
                gameScore.isHidden = false

            } else if node.name == "Setting" {

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
                settingButton.isHidden = false
                settingButton.isPaused = false

                if activePillars.count > 0 {
                    for (index, node) in activePillars.enumerated().reversed() {
                        node.removeFromParent()
                        activePillars.remove(at: index)
                    }
                }

                score = 0

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

                if activePillars.count > 0 {
                    for (index, node) in activePillars.enumerated().reversed() {
                        node.removeFromParent()
                        activePillars.remove(at: index)
                    }
                }

                score = 0

            } else if node.name == "Pause" {
                if isGamePaused == false {
                    pauseButton.text = "▸"
                    pauseButton.fontSize = 96
                    isGamePaused = true
                    physicsWorld.speed = 0
                } else {
                    pauseButton.text = "⏸︎"
                    pauseButton.fontSize = 72
                    isGamePaused = false
                    physicsWorld.speed = 1
                }
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {

        if activePillars.count > 0 {
            for (index, node) in activePillars.enumerated().reversed() {
                if node.position.x < -72 {
                    node.removeFromParent()
                    activePillars.remove(at: index)
                }
            }
        }

        if isGameStarted && isInGame && !isGamePaused {
            // 計算 deltaTime
            if lastUpdateTime == 0 {
                lastUpdateTime = currentTime
            }
            let deltaTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime

            // 累加時間
            timeAccumulator += deltaTime

            // 每到達指定間隔就觸發事件
            if timeAccumulator >= 4 {
                timeAccumulator = 0  // 重設累計時間
                createPillar()
            }
        }
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
