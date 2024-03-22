//
//  ViewController.swift
//  Ind02_Peram_Venkata_Ramana_Reddy
//
//  Created by Ramana on 2/28/24.
//

import UIKit

class ViewController: UIViewController {

    // Outlets for image views and buttons
    @IBOutlet weak var cell00: UIImageView!
    @IBOutlet weak var cell01: UIImageView!
    @IBOutlet weak var cell02: UIImageView!
    @IBOutlet weak var cell03: UIImageView!
    @IBOutlet weak var cell10: UIImageView!
    @IBOutlet weak var cell11: UIImageView!
    @IBOutlet weak var cell12: UIImageView!
    @IBOutlet weak var cell13: UIImageView!
    @IBOutlet weak var cell20: UIImageView!
    @IBOutlet weak var cell21: UIImageView!
    @IBOutlet weak var cell22: UIImageView!
    @IBOutlet weak var cell23: UIImageView!
    @IBOutlet weak var cell30: UIImageView!
    @IBOutlet weak var cell31: UIImageView!
    @IBOutlet weak var cell32: UIImageView!
    @IBOutlet weak var cell33: UIImageView!
    @IBOutlet weak var cell40: UIImageView!
    @IBOutlet weak var cell41: UIImageView!
    @IBOutlet weak var cell42: UIImageView!
    @IBOutlet weak var cell43: UIImageView!
    
    @IBOutlet weak var fullImage: UIImageView!
    
    @IBOutlet weak var shuffleClicked: UIButton!
    @IBOutlet weak var showHideAnswerClicked: UIButton!
    
    
    //Initialiing variables numRows and column
    let numRows = 5
    let numCols = 4
    
    //Initializing the empty position on the puzzle board
    var empPos: (row: Int, col: Int) = (4, 0)
    
    
    // Creating a 2D array of image views to get the puzzle state
    lazy var images =  [[cell00,cell01,cell02,cell03],
                        [cell10,cell11,cell12,cell13],
                        [cell20,cell21,cell22,cell23],
                        [cell30,cell31,cell32,cell33],
                        [cell40,cell41,cell42,cell43]]
    
    
    // Creating a 2D array of name of the image files
    var imageFiles =
        [["PistolPete-00.png","PistolPete-01.png","PistolPete-02.png","PistolPete-03.png"],
        ["PistolPete-10.png","PistolPete-11.png", "PistolPete-12.png","PistolPete-13.png"],
        ["PistolPete-20.png","PistolPete-21.png","PistolPete-22.png","PistolPete-23.png"],
        ["PistolPete-30.png","PistolPete-31.png","PistolPete-32.png","PistolPete-33.png"],
        ["PistolPete-40.png","PistolPete-41.png","PistolPete-42.png","PistolPete-43.png"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        puzzleState()
    }
    // Handle tap gesture on image views
    @IBAction func tapGestureHandle(_ sender: UITapGestureRecognizer) {
        //print("clicked Once")
        let newPos = ViewPosition(imageView: sender.view!)!
        if (empPos.0 == newPos.0 && (empPos.1 == newPos.1+1 || empPos.1 == newPos.1-1)||empPos.1 == newPos.1 && (empPos.0 == newPos.0+1 || empPos.0 == newPos.0-1)){
            swapImages(imgPos: newPos)
            if checkSolved() == true {
                shuffleClicked.setTitle("Solved! Shuffle Again?", for: .normal)
                shuffleClicked.backgroundColor = .systemPink
            }
        }
    }
    // Shuffle the puzzle
    @IBAction func shuffleTapped(_ sender: Any) {
        if shuffleClicked.titleLabel?.text == "Shuffle" {
            shuffle()
            shuffleClicked.isEnabled = false
            //print("Here")
        } else {
            shuffleClicked.setTitle("Shuffle", for: .normal)
            shuffleClicked.backgroundColor = .systemRed
        }
    }
    
    // Show or hide the answer
    @IBAction func showAnswerTapped(_ sender: Any) {
        if showHideAnswerClicked.titleLabel?.text == "Show Answer" {
            solvedState()
            showHideAnswerClicked.setTitle("Hide Answer", for: .normal)
        } else {
            showHideAnswerClicked.setTitle("Show Answer", for: .normal)
            puzzleState()
        }
    }
    
    // This function checks if the puzzle is solved and returns a boolean
    func checkSolved() -> Bool{
        for x in 0...numRows-1{
            for y in 0...numCols-1{
                if imageFiles[x][y] != "PistolPete-\(x)\(y).png" {
                    return false
                }
            }
        }
        shuffleClicked.isEnabled = true
        return true
    }
    
    // This displays solution to the puzzle.
    func solvedState(){
        for x in 0...numRows-1{
            for y in 0...numCols-1{
                let img = UIImage(named: "PistolPete-\(x)\(y).png")
                images[x][y]?.image = img
            }
        }
    }
    
    // A function that sets the ImageViews to the present position of the images.
    func puzzleState(){
        for x in 0...numRows-1{
            for y in 0...numCols-1{
                let img = UIImage(named: imageFiles[x][y])
                images[x][y]?.image = img
            }
        }
    }
    
    //This returns the position of a View in the 2-D array
    func ViewPosition(imageView: UIView) -> (Int, Int)? {
        for x in 0...numRows-1{
            for y in 0...numCols-1{
                if imageView == images[x][y]{
                    return (x, y)
                }
            }
        }
        return nil
    }
    
    // A custom function that handles the shuffle logic using the swapImages function.
    func shuffle() {
        for _ in stride(from: 200, to: 0, by: -1) {
            let nums = [-1,0,1]
            let direction = (nums.randomElement()!, nums.randomElement()!)
            let newPos: (Int, Int) = (empPos.0 + direction.0, empPos.1 + direction.1)
            if 0 <= newPos.0 && newPos.0 < numRows && 0 <= newPos.1 && newPos.1 < numCols {
                swapImages(imgPos: newPos)
                empPos = newPos
            }
        }
    }
    
    // This function swaps the images of the empty position with the image of a view tapped
    func swapImages(imgPos: (Int, Int)) {
        let tappedImg = images[imgPos.0][imgPos.1]?.image
        let tappedImgFile = imageFiles[imgPos.0][imgPos.1]
        imageFiles[imgPos.0][imgPos.1] = imageFiles[empPos.0][empPos.1]
        images[imgPos.0][imgPos.1]?.image = images[empPos.0][empPos.1]?.image
        imageFiles[empPos.0][empPos.1] = tappedImgFile
        images[empPos.0][empPos.1]?.image = tappedImg
        empPos = imgPos
    }
}

