//
//  TrackSelectionViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/16/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit
import SpriteKit

class TrackSelectionViewController: UIViewController {

    weak var networkService: NetworkService?;
    
    //Current track selected
    var trackID: Int = TrackID.MIN
    //Current Car type selected
    var carID: Int = CarID.MIN;
    //Current car color selecting
    var carColor: CarColor = .black;
    
    var gameMode: GameMode = .SOLO;
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var carImageParentView: UIView!
    @IBOutlet weak var carImage: UIImageView!
    
    @IBOutlet weak var startRaceButton: UIButton!
    @IBOutlet weak var prevCarButton: UIButton!
    @IBOutlet weak var nextCarButton: UIButton!
    @IBOutlet weak var prevTrackButton: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    @IBOutlet weak var changeColorButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Grey rounded border for views
        trackImage.layer.cornerRadius = 10;
        trackImage.layer.borderColor = UIColor.gray.cgColor;
        trackImage.layer.borderWidth = 3;
        
        carImageParentView.layer.cornerRadius = 10;
        carImageParentView.layer.borderColor = UIColor.gray.cgColor;
        carImageParentView.layer.borderWidth = 3;
        
        updateTrackImage();
        updateCarImage();
        
        //Hide buttons if gameMode is DISPLAY
        //because the controller device is where they will be pressed
        if gameMode == .DISPLAY {
            hideButtons();
        }
    }
    
    func playButtonSound(){
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav");
    }

    func hideButtons() {
        changeColorButton.isHidden = true;
        startRaceButton.isHidden = true;
        prevCarButton.isHidden = true;
        nextCarButton.isHidden = true;
        prevTrackButton.isHidden = true;
        nextTrackButton.isHidden = true;
    }
    
    //Set trackImage to correct track image using the currently selected track
    func updateTrackImage() {
        trackImage.image = UIImage(named: TrackID.toString(trackID).lowercased());
    }
    
    //Set the carImage to the correct image using currently selected car id and color
    func updateCarImage() {
        let imageName = getCarTextureName(id: carID, color: carColor);
        carImage.image = UIImage(named: imageName);
    }

    // MARK: - Buttons
    
    @IBAction func nextTrack(_ sender: UIButton?) {
        nextTrack();
        playButtonSound();
        networkService?.send(messageType:  .TRACK_NEXT)
    }
    
    func nextTrack() {
        trackID = TrackID.getNextID(trackID);
        updateTrackImage();
    }
    
    @IBAction func prevTrack(_ sender: UIButton?) {
        prevTrack();
        playButtonSound();
        networkService?.send(messageType: .TRACK_PREV)
    }
    
    func prevTrack() {
        trackID = TrackID.getPreviousID(trackID);
        updateTrackImage();
    }
    
    @IBAction func nextCar(_ sender: UIButton?) {
        nextCar();
        playButtonSound();
        networkService?.send(messageType: .CAR_NEXT)
    }
    
    func nextCar(){
        carID = CarID.getNextID(carID);
        updateCarImage();
    }
    
    @IBAction func prevCar(_ sender: UIButton?) {
        prevCar();
        playButtonSound();
        networkService?.send(messageType: .CAR_PREV)
    }
    
    func prevCar() {
        carID = CarID.getPreviousID(carID);
        updateCarImage();
    }
    
    @IBAction func nextCarColor(_ sender: UIButton?) {
        nextCarColor();
        playButtonSound();
        networkService?.send(messageType: .CAR_COLOR)
    }
    
    func nextCarColor() {
        carColor.next();
        updateCarImage();
    }
    
    @IBAction func start(_ sender: UIButton) {
        start();
        playButtonSound();
        networkService?.send(messageType: .NAV_START_RACE);
    }
    
    //Navigate to GameViewController
    func start() {
        if let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            //Set required values for gameViewController using current selections
            gameViewController.gameMode = gameMode;
            gameViewController.carType = getCarTextureName(id: carID, color: carColor);
            gameViewController.track = TrackID.toString(trackID);
            //Pass along the network service so the gameViewController
            //can use it
            gameViewController.networkService = networkService;
            gameViewController.trackSelectionViewController = self;
            navigationController?.pushViewController(gameViewController, animated: true)
        }
    }
    
    //Navigate back to previous controller
    //Disconnect from network if connected
    @IBAction func backButton(_ sender: UIButton) {
        playButtonSound();
        networkService?.send(messageType: .DISCONNECT);
        _ = navigationController?.popViewController(animated: true)
    }
}



extension TrackSelectionViewController: NetworkServiceDelegate {
    func handleMessage(message: MessageBase) {
        
        //These are the expected messages that this
        //view controller will received
        switch message.type {
        case .CAR_NEXT:
            nextCar();
        case .CAR_PREV:
            prevCar();
        case .TRACK_NEXT:
            nextTrack();
        case .TRACK_PREV:
            prevTrack();
        case .CAR_COLOR:
            nextCarColor();
        case .NAV_START_RACE:
            start();
        case .DISCONNECT:
            _ = navigationController?.popViewController(animated: true)
        default:
            fatalError("Unexpected Network Message \(message.type)")
        }
    }
}
