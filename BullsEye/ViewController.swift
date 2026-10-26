//
//  ViewController.swift
//  BullsEye
//
//  Created by Frederick Cowgill on 8/14/19.
//  Copyright © 2019 Frederick Cowgill. All rights reserved.
// This is the controller for the Hit Me button
//
//  ===========================================================================
//  BUG-FIX NOTES (2026)
//  ===========================================================================
//  1. SCORE BUG: the old code added points to the score BEFORE adding the
//     bonus (+100 for perfect, +50 for off-by-one). So the alert said "You
//     scored 200 points" but your score only went up by 100. The score now
//     matches what the alert says. No more points off target!
//
//  2. The alert title was stored in `title`, which is the view controller's
//     own screen title property - so every round quietly renamed the screen.
//     It's a local constant now.
//
//  3. The slider used `Int(slider.value)`, which chops off decimals (49.9
//     became 49). It now rounds, matching what viewDidLoad already did, so
//     "dead center" really counts as dead center.
//
//  4. The image literals (#imageLiteral) were replaced with UIImage(named:),
//     which reads more clearly in current Xcode and won't crash if an image is
//     renamed (the slider just keeps its default look instead).
//  ===========================================================================

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

        //this will show the current value of the slider in the message after the hit me button is pushed
        currentValue = Int(slider.value.rounded())
        startNewGame()

        if let thumbImageNormal = UIImage(named: "SliderThumb-Normal") {
            slider.setThumbImage(thumbImageNormal, for: .normal)
        }

        if let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted") {
            slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        }

        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

        if let trackLeftImage = UIImage(named: "SliderTrackLeft") {
            slider.setMinimumTrackImage(trackLeftImage.resizableImage(withCapInsets: insets), for: .normal)
        }

        if let trackRightImage = UIImage(named: "SliderTrackRight") {
            slider.setMaximumTrackImage(trackRightImage.resizableImage(withCapInsets: insets), for: .normal)
        }
    }

// this code will tie the hit me button to the message function below.
    @IBAction func showAlert(){

        let difference = abs(targetValue - currentValue)
        var points = 100 - difference

        // Work out the title and any bonus FIRST...
        let alertTitle: String
        if difference == 0 {
            alertTitle = "Perfect!"
            points += 100
        } else if difference < 5 {
            alertTitle = "You almost had it!"
            if difference == 1 {
                points += 50
            }
        } else if difference < 10 {
            alertTitle = "Pretty Good"
        } else {
            alertTitle = "Not even close..."
        }

        // ...THEN add to the score, so the score includes the bonus. (Bullseye!)
        score += points

        let message = "You scored \(points) points"

        //This is the UI alert controller
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)

        //This is the UI alert action
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            //This is a swift closure. [weak self] means the alert doesn't keep the
            //screen alive in memory after it's gone.
            [weak self] _ in
            self?.startNewRound()
        })

        //This is telling the alert controller to add the button controller to itself
        alert.addAction(action)

        //This is telling the alert to be animated when hit
        present(alert, animated: true, completion: nil)

    }

    //This code will determine the value that the slider is at and then display it on the screen for the user
    @IBAction func sliderMoved(_ slider: UISlider) {

        //This will convert the value from a float to an integer (rounded, not chopped - see note 3)
        currentValue = Int(slider.value.rounded())

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
