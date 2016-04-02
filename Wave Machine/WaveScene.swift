//
//  WaveScene.swift
//  Wave Machine
//
//  Created by Matthew Schlegel on 1/19/16.
//  Copyright © 2016 Matthew Schlegel. All rights reserved.
//

import SpriteKit
import AudioKit

class WaveScene: SKScene {
	
	
	
	var nodes = [SKNode]()
	var nodePositions = [CGFloat]()
	var theta:Double = 0
	var previousTime:CFTimeInterval = CFTimeInterval.init()
	var soundNodesArray = [SoundNode]()
	
	var touchDictionary:[UITouch:SoundNode] = [UITouch:SoundNode]()
	
	var selectedSoundNode:SoundNode? = nil
	var audioCollection: AudioCollection
	
	var garbageNode:SKSpriteNode? = nil
	
	var menuNode: NodeMenu
	
	override init() {
		audioCollection = AudioCollection(numNodes: 5)
		menuNode = NodeMenu()
		super.init()
    
	}
    
	override init(size: CGSize) {
		audioCollection = AudioCollection(numNodes: 5)
		menuNode = NodeMenu()
		super.init(size: size)
		self.name = "WaveScene"
	}
    
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    
	override func didMoveToView(view: SKView) {
      
		let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(WaveScene.longPressHandler(_:)))
		longPressRecognizer.minimumPressDuration = 1.0
		
		let longPressTwoTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(WaveScene.longPressHandler(_:)))
		longPressTwoTapRecognizer.numberOfTapsRequired = 1
		longPressTwoTapRecognizer.minimumPressDuration = 0.5
      
		print(self.scene)
		self.view!.addGestureRecognizer(longPressRecognizer)
		self.view!.addGestureRecognizer(longPressTwoTapRecognizer)
		print("init")
        
        
		let plusNode = SKSpriteNode(imageNamed: "plus")
		plusNode.size = CGSize(width: 30, height: 30)
		plusNode.position = CGPoint(x: 30, y: 30)
		plusNode.name = "PlusNode"
		self.addChild(plusNode)

		
		garbageNode = SKSpriteNode(imageNamed: "garbage")
		garbageNode!.size = CGSize(width: 30, height: 30)
		garbageNode!.position = CGPoint(x: UIScreen.mainScreen().bounds.width - 30, y: 30)
		garbageNode!.name = "GarbageNode"
		garbageNode!.alpha = 1
		garbageNode!.zPosition = -3
		self.addChild(garbageNode!)
		
		
		makeWaveNodes()
		
		
		menuNode.position = CGPoint(x: 0, y: UIScreen.mainScreen().bounds.height - menuNode.boxSize.height)
		self.addChild(menuNode)
		menuNode.alpha = 0
		
			
	}
	
	func makeTouchNode(){
        
		makeTouchNodeAt(CGPoint(x: 100, y: 100))
        
	}
    
	func makeTouchNodeAt(position:CGPoint) -> Bool{
        
		if(soundNodesArray.count < 3){
			let audio = audioCollection.getNextAvailableNode()
			if(audio != nil){
            	let node = SoundNode(audio: audio!)
				self.addChild(node)
				self.soundNodesArray.append(node)
				
				node.position = position
				return true
			}
			else{
				print("No Audio Nodes available")
				return false
			}
		}
		else{
			print("No More Touch Nodes allowed")
			return false
		}
	}
	
	func removeTouchNode(node:SoundNode) -> Void {

		audioCollection.releaseNode(node.audioNode)
		node.removeFromParent()
		soundNodesArray.removeAtIndex(soundNodesArray.indexOf(node)!)
		
	}
	
    
	func makeWaveNodes(){
        
		let nodeRadius:CGFloat = 2
		for i in 0...Int(self.size.height/(nodeRadius*2))+1{
				let node = SKShapeNode(circleOfRadius: nodeRadius)
				node.name = "WaveNode"
				node.physicsBody = SKPhysicsBody(circleOfRadius: nodeRadius)
				node.physicsBody?.friction = 0
				node.physicsBody?.mass = 0
				node.fillColor = UIColor.whiteColor()
				node.position = CGPoint(x: self.size.width/2, y: CGFloat(i)*nodeRadius*2)
				node.physicsBody?.dynamic = false
				self.addChild(node)
				self.nodes.append(node)
				self.nodePositions.append(node.position.x)
		}
		(nodes[nodes.count/2] as! SKShapeNode).fillColor = UIColor.redColor()
			
	}
	
	/*

	Long Press Handler

	*/
	
	func longPressHandler(sender: UILongPressGestureRecognizer){
		
		print("NumTaps:", sender.numberOfTapsRequired)
		
		if(sender.state == UIGestureRecognizerState.Ended) {
			print("Long Press Ended")
			print("Touch Dictionary Count: ", touchDictionary.count)
		}
		if(sender.state == UIGestureRecognizerState.Began){
			let node = self.nodeAtPoint(convertPointFromView(sender.locationInView(self.view!)))
			print("Long Press Began")
			if (node.name == "SoundNodeVisual"){
				selectedSoundNode = (node.parent) as? SoundNode
				if selectedSoundNode != nil {
					selectedSoundNode?.selected = true
				}
				menuNode.alpha = 1
				
			}
			if (node.name == "WaveScene" && sender.numberOfTapsRequired == 1){
				//Create a Touch Node Here.
				makeTouchNode()
			}
		}
	}
	
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		for touch in touches{
			let location = touch.locationInNode(self)
			if let node:SKNode? = touchDictionary[touch] {
				node?.position = location
			}
		}
		
	}
    
    
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
	/* Called when a touch begins */
		
	//TODO: Redo touchesBegan
		
		print("Touches Began");
		//makeTouchNode()
		for touch:AnyObject in touches {
			let location = touch.locationInNode(self)
			let node = self.nodeAtPoint(location)

			switch(node.name){
			case "PlusNode"?:
				print("Node: \(node.name)")
				makeTouchNode()
			case "SoundNode"?:
				print("Node: \(node.name)")
				let touchObj = touch as! UITouch
				touchDictionary[touchObj] = node as? SoundNode
			case "SoundNodeVisual"?:
				print("Node: \(node.name)")
				let touchObj = touch as! UITouch
				touchDictionary[touchObj] = node.parent as? SoundNode
			case nil:
				print("No Node Found", node)
			default:
				print("Node: \(node.name)")
			}
		}
	}

	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
	//TODO: Redo touchesEnded
		
		print("Touches Ended")
		
		if(selectedSoundNode != nil){
			selectedSoundNode?.selected = false;
			selectedSoundNode = nil
			menuNode.alpha = 0
		}
		
		for touch:UITouch in touches{
			if let _ = touchDictionary[touch]{
				let nodes = self.nodesAtPoint(touch.locationInNode(self))
				if(nodes.contains(garbageNode!)){
					print("delete",touchDictionary[touch]?.name)
					removeTouchNode(touchDictionary[touch]!)
				}
				touchDictionary[touch] = nil
			}
		}
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		//TODO: Add touchesCancelled
		print("Touches Cancelled")
		touchDictionary.removeAll()
	}
	
	
    
	override func update(currentTime: CFTimeInterval) {
			/* Called before each frame is rendered */
		if(selectedSoundNode == nil){
			theta += 0.00001/(currentTime - previousTime)
			
			if(theta > M_PI*4){
				theta = theta - M_PI*4
			}
			
			let dtheta = (M_PI_4/16)/Double(nodes.count)
			var tempTheta = theta
			var multipliers:[Double] = [Double]()
			var volumes:[Double] = [Double]()
			if(soundNodesArray.isEmpty) {
				multipliers.append(0)
				volumes.append(0)
			}
			else {
				for i in 0..<soundNodesArray.count{
						multipliers.append(soundNodesArray[i].frequency)
						volumes.append(soundNodesArray[i].amplitude)
				}
			}
			var i = 0
			for node in nodes{
				tempTheta = theta + dtheta*Double(i)
				node.position.x = self.frame.width/2
				for i in 0..<soundNodesArray.count{
					node.position.x += CGFloat(volumes[i]*sin(multipliers[i] * tempTheta))
				}
				i += 1
			}
			previousTime = currentTime
		}
	}
}

