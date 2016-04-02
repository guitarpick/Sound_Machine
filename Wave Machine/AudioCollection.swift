//
//  AudioCollection.swift
//  Wave Machine
//
//  Created by Matthew Schlegel on 2/29/16.
//  Copyright © 2016 Matthew Schlegel. All rights reserved.
//

import Foundation
import AudioKit


class AudioCollection {
	var mixer = AKMixer()
  var audioNodes = [AKNode]()
  var audioNodesAvailable = [Bool]()
  
	init(numNodes:Int){
    
    for _ in 0...numNodes{
			let newNode = AKOscillator()
			audioNodes.append(newNode)
		}
	
    mixer = AKMixer(audioNodes[0])
    for i in 1...numNodes{
      mixer.connect(audioNodes[i])
    }
    
    audioNodesAvailable = [Bool](count: numNodes, repeatedValue: true);

    AudioKit.output = mixer;
		AudioKit.start()
		mixer.start()
    
  }
  
  func findNodeIndex(node: AKNode)->(Int?){
    return audioNodes.indexOf(node)
  }
  
  func releaseNode(node: AKNode){
    audioNodesAvailable[(audioNodes.indexOf(node))!] = true
		print(audioNodesAvailable)
		(node as! AKOscillator).stop()
  }
  
  func getNextAvailableNode()->(AKNode?){
    let index = audioNodesAvailable.indexOf(true)
    if(index != nil){
      audioNodesAvailable[index!] = false
	  print(audioNodesAvailable)
      return audioNodes[index!]
    }
    else{
      return nil
    }
  }
	
	func pauseSound() -> Void {
		for node in audioNodes{
			(node as! AKOscillator).stop()
		}
	}
	
	func startSound() -> Void {
		for i in 0..<audioNodes.count{
			if(audioNodesAvailable[i] == false){
				(audioNodes[i] as! AKOscillator).start()
			}
		}
	}
}

