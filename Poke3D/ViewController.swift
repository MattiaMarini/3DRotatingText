//
//  ViewController.swift
//  Poke3D
//
//  Created by Mattia Marini on 14/08/2019.
//  Copyright © 2019 Mattia Marini. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "PokemonCards", bundle: Bundle.main) {
        configuration.trackingImages = imageToTrack
        configuration.maximumNumberOfTrackedImages = 1
        print("Images successfully tracked")
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi/2
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0)
            node.addChildNode(planeNode)
            updateText(text: imageAnchor.referenceImage.name!, forNode: planeNode)
            
        }
        
        return node
    }
 
    func updateText(text: String, forNode node: SCNNode) {
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.scale = SCNVector3(0.005, 0.005, 0.005)
        textNode.eulerAngles.x = .pi/2
        textNode.position = SCNVector3(node.position.x/2, node.position.y/2, 0.1)
        node.addChildNode(textNode)
        rotateText(forText: textNode)
        
    }
    
    func rotateText (forText textToRotate: SCNNode) {
        let (minVec, maxVec) = textToRotate.boundingBox
        textToRotate.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x)/2 + minVec.x, (maxVec.y - minVec.y)/2 + minVec.y, 0)
        
        let loop = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: 5, duration: 3))
        textToRotate.runAction(loop)
    
    }
    
}
