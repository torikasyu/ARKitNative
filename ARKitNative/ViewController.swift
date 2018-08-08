//
//  ViewController.swift
//  ARKitNative
//
//  Created by Hiroki TANAKA on 2018/08/07.
//  Copyright © 2018年 Hiroki TANAKA. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController,ARSCNViewDelegate {
    
    @IBOutlet weak var mainSceneView: ARSCNView!
    
    //検出用configを作成
    let configuration = ARWorldTrackingConfiguration()
    var selectedItem: String? = "model"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        registerGestureRecognizers()
    }
    
    /// ARSCNiew初期化設定
    func initialize (){
        self.mainSceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.configuration.planeDetection = .horizontal
        self.mainSceneView.session.run(configuration)
        self.mainSceneView.autoenablesDefaultLighting = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ///　メインのビューのタップを検知するように設定する
    func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.mainSceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func butonPutobj(_ sender: Any) {
        selectedItem = "model"
    }

    @objc func tapped(sender: UITapGestureRecognizer) {
        // タップされた位置を取得する
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        
        // タップされた位置のARアンカーを探す
        let hitTest = sceneView.hitTest(tapLocation, types: .estimatedHorizontalPlane)
        if !hitTest.isEmpty {
            // タップした箇所が取得できていればitemを追加
            self.addItem(hitTestResult: hitTest.first!)
        }
        else
        {
            print("Not hit")
        }
    }
    
    /// アイテム配置メソッド
    func addItem(hitTestResult: ARHitTestResult) {
        //if let selectedItem = self.selectedItem {
            
            // アセットのより、シーンを作成
            let scene = SCNScene(named: "Model.scnassets/toy.scn")!
            
            // ノード作成
        let modelNode = SCNNode()
            //let node = (scene.rootNode.childNode(withName: "model", recursively: false))!
        for childNode in scene.rootNode.childNodes {
            modelNode.addChildNode(childNode)
        }
            // 現実世界の座標を取得
            let transform = hitTestResult.worldTransform
            let thirdColumn = transform.columns.3
            
            // アイテムの配置
            modelNode.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            modelNode.scale = SCNVector3(0.1,0.1,0.1)
            self.mainSceneView.scene.rootNode.addChildNode(modelNode)
        //}
    }

}

