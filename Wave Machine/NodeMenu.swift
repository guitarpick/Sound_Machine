//
//  NodeMenu.swift
//  Wave Machine
//
//  Created by Matthew Schlegel on 3/25/16.
//  Copyright © 2016 Matthew Schlegel. All rights reserved.
//

import SpriteKit
//import Foundation


class NodeMenu: SKNode {
	
	//Options: Delete, Frequency, Octave, Note, Sound
	
	
	let itemSize:CGFloat = 40
	var boxSize:CGSize = CGSize()
	
	
	override init() {
		
		let screenSize = UIScreen.mainScreen().bounds
		boxSize.width = screenSize.width
		boxSize.height = screenSize.height/10
		
		super.init()
		
		//EARLY VISUALS FOR NODEMENU
		
		//let backgroundNode = SKEffectNode();
		let backgroundNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: boxSize.width, height: boxSize.height))
		//backgroundNode.filter = CIFilter.init(name: "CIGaussianBlur")
		backgroundNode.strokeColor = UIColor.clearColor()
		backgroundNode.fillColor = UIColor.grayColor()
		backgroundNode.alpha = 0.5
		//backgroundNode.blendMode = SKBlendMode.Alpha
		//backgroundNode.blendMode = SKBlendMode.MultiplyX2
		backgroundNode.name = "MenuBackground"
		self.addChild(backgroundNode)
		
		let textNode = SKLabelNode(text: "WIP")
		textNode.color = UIColor.whiteColor()
		textNode.position = CGPoint(x: 250, y: 5)
		textNode.fontSize = 75
		self.addChild(textNode)
		
		let noteNode = SKSpriteNode(imageNamed: "note")
		noteNode.size = CGSize(width: itemSize, height: itemSize)
		self.addChild(noteNode)
		
		noteNode.position = CGPoint(x: 30, y: self.boxSize.height/2)
		
		let octaveNode = SKSpriteNode(imageNamed: "octave")
		octaveNode.size = CGSize(width: itemSize, height: itemSize)
		self.addChild(octaveNode)
		
		octaveNode.position = CGPoint(x: noteNode.position.x + noteNode.size.width + 10, y: self.boxSize.height/2)
		
		let hzNode = SKSpriteNode(imageNamed: "hz")
		hzNode.size = CGSize(width: itemSize, height: itemSize)
		self.addChild(hzNode)
		
		hzNode.position = CGPoint(x: octaveNode.position.x + octaveNode.size.width + 10, y: self.boxSize.height/2)
		
		
		
		
		self.userInteractionEnabled = true
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		
		
	}
	
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		
		
	}
	
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		
		
	}
}




