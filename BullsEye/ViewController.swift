//
//  ViewController.swift
//  BullsEye
//
//  Created by Frederick Cowgill on 8/14/19.
//  Copyright © 2019 Frederick Cowgill. All rights reserved.
// This is the controller for the Hit Me button

import UIKit

class ViewController: UIViewController {
    //this will store the value of various things for later use
    var currentValue = 0
    var targetValue = 0
    var score = 0
    var round = 0

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let roundedValue = slider.value.rounded()
        
       //this will show the current value of the slider in the message after the hit me button is pushed
        currentValue = Int(roundedValue)
       startNewGame()
        
        let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)

        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        
        let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        let trackLeftResizeable = trackLeftImage.resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizeable, for: .normal)
        
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        let trackRightResizeable = trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizeable, for: .normal)
    }
    
// this code will tie the hit me button to the message function below.
    @IBAction func showAlert(){
        
        let difference = abs(targetValue - currentValue)
        var points = 100 - difference

        
        score += points
        if difference == 0 {
            title = "Perfect!"
            points += 100
        } else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
            points += 50
            }
        } else if difference < 10 {
            title = "Pretty Good"
        } else {
            title = "Not even close..."
        }
        
        let message = "You scored \(points) points"
        
        //This is the UI alert controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //This is the UI alert action
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            //This is a swift closure
            action in
            self.startNewRound()
            
        })
        
        //This is telling the alert controller to add the button controller to itself
        alert.addAction(action)
        
        //This is telling the alert to be animated when hit
        present(alert, animated: true, completion: nil)
        
    }
    
    //This code will determine the value that the slider is at and then display it on the screen for the user
    @IBAction func sliderMoved(_ slider: UISlider) {
        
        //This will convert the value from a float to an integer
        currentValue = Int(slider.value)
        
    }
    
    func startNewRound(){
        round += 1
        targetValue = Int.random(in: 1...100)
        currentValue = 50
        slider.value = Float(currentValue)
        updateLabels()
    }
    
    //always make sure these are pointing to the correct labels on the main.storyboard, if they are not the application will crash.
    
    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }
    
    @IBAction func startNewGame(){
        
        score = 0
        round = 0
        startNewRound()
    }
    
}

