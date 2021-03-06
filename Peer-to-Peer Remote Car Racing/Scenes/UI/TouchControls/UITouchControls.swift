//
//  UITouchControlsJoystick.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/19/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import Foundation
import SpriteKit


//The class representing the UITouchControls.sks
class UITouchControls : SceneRootNode {
    
    weak var gameScene : BaseGameScene?;
    var inputControl : InputControl!;
    var pauseButton: FTButtonNode!;
    
    var gasButton: FTButtonNode!;
    var reverseButton : FTButtonNode!;
    var buttons: SKNode!;
    
    init(gameScene: BaseGameScene, controlType: ControlType) {
        super.init(fileNamed: String(describing: UITouchControls.self))!;
        
        let js = childNode(withName: ".//joystick") as! AnalogJoystick;
    
        //Setup pause button so it is clickable and styled
        buttons = childNode(withName: ".//buttons")!;
        setupPauseButton(gameScene: gameScene);
        
        //Setup correct control type based on value passed in
        switch controlType {
        case .Joystick:
            inputControl = JoystickInput(analogJoystick: js);
            //hide gas/reverse buttons when only joystick is necessary
            buttons.isHidden = true;
        case .JoystickButtons:
            //Setup buttons so they are clickable and styled
            setupGasReverseButtons();
            inputControl = JoystickButtonInput(analogJoystick: js);
        case .TiltButtons:
            //Setup buttons so they are clickable and styled
            setupGasReverseButtons();
            inputControl = TiltControls()
            //Hide joystick when using tilt
            js.isHidden = true;
        }

     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Changes the pause button form SKSpriteNode to FTButtonNode
    //This allows it to be styled and have on touch triggers
    func setupPauseButton(gameScene: BaseGameScene){
        let pause = childNode(withName: ".//pause") as! SKSpriteNode;
        pause.removeFromParent();
        pauseButton = FTButtonNode(normalTexture: pause.texture, selectedTexture: pause.texture, disabledTexture: pause.texture);
        pauseButton.position = pause.position;
        pauseButton.setButtonAction(target: gameScene, triggerEvent: .TouchUpInside, action: #selector(BaseGameScene.pause));
        top.addChild(pauseButton);
    }
    
    //Changes the gas and reverse buttons form SKSpriteNode to FTButtonNode
    //This allows them to be styled and have on touch triggers
    func setupGasReverseButtons() {
        //Setup Gas Button Node
        let gas = buttons.childNode(withName: ".//gas") as! SKSpriteNode;
        gas.removeFromParent();
        gasButton = FTButtonNode(normalTexture: gas.texture, selectedTexture: gas.texture, disabledTexture: gas.texture);
        gasButton.position = gas.position;
        gasButton.xScale = gas.xScale;
        gasButton.yScale = gas.yScale;
        gasButton.setButtonAction(target: self, triggerEvent: .TouchDown, action: #selector(UITouchControls.gasDown));
        gasButton.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(UITouchControls.gasUp))
        buttons.addChild(gasButton);
        
        //Setup Reverse Button Node
        let reverse = buttons.childNode(withName: ".//reverse") as! SKSpriteNode;
        reverse.removeFromParent();
        reverseButton = FTButtonNode(normalTexture: reverse.texture, selectedTexture: reverse.texture, disabledTexture: reverse.texture);
        reverseButton.position = reverse.position;
        reverseButton.xScale = reverse.xScale;
        reverseButton.yScale = reverse.yScale;
        reverseButton.setButtonAction(target: self, triggerEvent: .TouchDown, action: #selector(UITouchControls.reverseDown));
        
        reverseButton.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(UITouchControls.reverseUp))
        buttons.addChild(reverseButton);
        
        
    }
    
    //Adds the Debug WIN button to the UI
    func addDebugHUD(gameScene: BaseGameScene) {
        let t = SKTexture(imageNamed: "blackButton");
        let t2 = SKTexture(imageNamed: "blackButtonHighlight")
        let btn = FTButtonNode(normalTexture: t, selectedTexture: t2, disabledTexture: t);
        btn.setButtonLabel(title: "WIN", font: "Arial", fontSize: 22);
        btn.fontColor(color:.white);
        btn.position = pauseButton.position;
        btn.centerRect = CGRect(x: 0.49, y: 0.49, width: 0.02, height: 0.02);
        btn.size = pauseButton.size;
        btn.position.x -= btn.size.width * 1.01;
        btn.label.zPosition = 1;
        btn.name = "debug_finish";
        btn.setButtonAction(target: gameScene, triggerEvent: .TouchUpInside, action: #selector(BaseGameScene.debugWin));
        top.addChild(btn);
        
    }
 
    //Actions for when gas/reverse button are touched and released
    
    @objc func gasDown() {
        inputControl.velocity.y = 1.0;
    }
    
    @objc func gasUp() {
        inputControl.velocity.y = 0.0;
    }
    
    @objc func reverseDown(){
        inputControl.velocity.y = -1.0;
    }
    
    @objc func reverseUp() {
        inputControl.velocity.y = 0.0;
    }
}
