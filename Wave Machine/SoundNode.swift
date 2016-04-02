//
//  touchNode.swift
//  Wave Machine
//
//  Created by Matthew Schlegel on 12/18/15.
//  Copyright © 2015 Matthew Schlegel. All rights reserved.
//

import UIKit
import AudioKit
import SpriteKit

class SoundNode: SKSpriteNode{
    
    static let A_Frequencies = []
    
    let visualSize:CGFloat = 24
    let childNodeSize:CGFloat = 20
    let childNodeLocation:CGFloat = 30
	
	
    var visualNode:SKShapeNode
    var audioNode: AKNode
    var octave:Int = 4
    var frequency:Double
    var amplitude:Double
    var mute:Bool = false{
        didSet {
            
        }
    }
    
    var selected:Bool = false {
		//TODO: selected set handeling.
			didSet {
				if selected{
					visualNode.strokeColor = UIColor.yellowColor()
				} else {
					visualNode.strokeColor = UIColor.whiteColor()
				}
			}
		}
    
    var options:Bool = false{
        didSet{
			//TODO: Handeling options
		
        }
    }
    
    override var position: CGPoint{
        didSet{
			//print("PositionSet")
            //(self.parent as! SKScene).size.height
            if let s = self.scene{
                frequency = (((Double(position.y)-50)/(Double(s.size.height) - 100))*440 + 440)
                frequency = frequency*pow(2.0,Double(octave)-4.0)
                amplitude = Double(position.x/10)
                (audioNode as! AKOscillator).frequency = frequency
                (audioNode as! AKOscillator).amplitude = amplitude
                //print(frequency, position, s.size.height)
            } else {
                print("TouchNode: ","Not in scene")
                //print(self)
            }
        }
    }
	
    
    init(audio:AKNode) {
      
        audioNode = audio;

		
        //Initialize Custom Properties
        visualNode = SKShapeNode(circleOfRadius: visualSize)
        visualNode.position = CGPoint(x: 0, y: 0)
        visualNode.alpha = 0.8
        visualNode.fillColor = UIColor.redColor()
				visualNode.zPosition = 0
        visualNode.physicsBody?.dynamic = false
        visualNode.name = "SoundNodeVisual"
		
        octave = 4
        frequency = 0
        amplitude = 0
        
        //Super Initialization
				super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: visualSize, height: visualSize))
        
        //Initialize parent's properties
        self.name = "SoundNode"
        

        self.addChild(visualNode)
			
        (audioNode as! AKOscillator).play()

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTo(freq:Double, amp:Double){
        
    }
    
    func setTo(freq:Double){
        setTo(freq,amp: self.amplitude)
    }
}


