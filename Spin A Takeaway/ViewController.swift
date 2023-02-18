//
//  ViewController.swift
//  Spin A Takeaway
//
//  Created by Richard Price on 18/02/2023.
//


//  ViewController.swift
//  Spin A Takeaway
//
//  Created by Richard Price on 18/02/2023.
//

import UIKit

class ViewController: UIViewController {
    
    let options = ["Italian", "Chinese", "Indian", "Thai", "Mexican", "Pizza", "Burger", "Sushi"]
    let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let wordLabelFontSize: CGFloat = 20
    var selectedOption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoImageView = UIImageView(image: UIImage(named: "bg2"))
        logoImageView.frame = CGRect(x: view.frame.maxX / 7, y: 25, width: 300, height: 250)
        view.addSubview(logoImageView)

        
        // Configure the circle view
        circleView.backgroundColor = UIColor.clear
        circleView.layer.cornerRadius = circleView.bounds.width / 2
        circleView.layer.borderWidth = 4
        circleView.layer.borderColor = UIColor.white.cgColor
        circleView.center = view.center
        view.addSubview(circleView)
        
        // Add separator lines to the circle
        let separatorLayer = CAShapeLayer()
        separatorLayer.strokeColor = UIColor.white.cgColor
        separatorLayer.lineWidth = 1.5
        let path = UIBezierPath()
        for i in 0..<options.count {
            let radius: CGFloat = 125
            let lineLength: CGFloat = 2
            let x = circleView.bounds.midX + (radius - lineLength) * cos(CGFloat(i) * (2 * CGFloat.pi / CGFloat(options.count)))
            let y = circleView.bounds.midY + (radius - lineLength) * sin(CGFloat(i) * (2 * CGFloat.pi / CGFloat(options.count)))
            path.move(to: CGPoint(x: circleView.bounds.midX, y: circleView.bounds.midY))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        separatorLayer.path = path.cgPath
        circleView.layer.addSublayer(separatorLayer)
        
        // Add the word labels to the circle
        for i in 0..<options.count {
            let radius: CGFloat = 105
            let wordLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
            wordLabel.center = CGPoint(x: circleView.bounds.midX + radius * cos(CGFloat(i) * (2 * CGFloat.pi / CGFloat(options.count))), y: circleView.bounds.midY + radius * sin(CGFloat(i) * (2 * CGFloat.pi / CGFloat(options.count))))
            wordLabel.transform = CGAffineTransform(rotationAngle: CGFloat(i) * (2 * CGFloat.pi / CGFloat(options.count)))
            wordLabel.textAlignment = .center
            wordLabel.textColor = UIColor.white
            wordLabel.font = UIFont(name: "AvenirNext-Bold", size: wordLabelFontSize)
            wordLabel.adjustsFontSizeToFitWidth = true
            wordLabel.minimumScaleFactor = 0.5
            wordLabel.text = options[i]
            circleView.addSubview(wordLabel)
        }
        
        // Add a tap gesture recognizer to the circle view
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        circleView.addGestureRecognizer(tapRecognizer)
        
        // Set the background to a gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.38, green: 0.71, blue: 0.80, alpha: 1.0).cgColor, UIColor(red: 0.91, green: 0.47, blue: 0.67, alpha: 1.0).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Disable user interaction while the wheel is spinning
        view.isUserInteractionEnabled = false
        
        // Calculate a random number of rotations to spin
        let numRotations = CGFloat(Int.random(in: 3...5))
        let finalAngle = numRotations * (2 * CGFloat.pi) + CGFloat.random(in: 0...(2 * CGFloat.pi))
        
        // Animate the circle view to spin
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        spinAnimation.toValue = finalAngle
        spinAnimation.duration = 5.0
        spinAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        spinAnimation.isRemovedOnCompletion = false
        spinAnimation.fillMode = .forwards
        circleView.layer.add(spinAnimation, forKey: "spin")
        
        // Animate the word labels to rotate in the opposite direction of the wheel
        let wordAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        wordAnimation.toValue = -finalAngle
        wordAnimation.duration = 5.0
        wordAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        wordAnimation.isRemovedOnCompletion = false
        wordAnimation.fillMode = .forwards
        for subview in circleView.subviews {
            subview.layer.add(wordAnimation, forKey: "spin")
        }
        
        // Enable user interaction after the wheel has stopped spinning
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.view.isUserInteractionEnabled = true
            let selectedOptionIndex = Int(finalAngle / (2 * CGFloat.pi / CGFloat(self.options.count))) % self.options.count
            self.selectedOption = self.options[selectedOptionIndex]
            print("Selected option: \(self.selectedOption ?? "none")")
            let alert = UIAlertController(title: "Spin A Takeaway", message: "You should try \(self.selectedOption ?? "something else")!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            // Reset the circle view to its initial state
            self.circleView.layer.removeAllAnimations()
            for subview in self.circleView.subviews {
                subview.layer.removeAllAnimations()
            }
        }
    }
}
    
    
