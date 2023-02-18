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
    
    let sayings = ["Mmm...I wonder what you're having tonight.", "The suspense is hard to take.", "Feeling lucky?", "I'm excited to see what you get!", "Bon appetit!"]

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
        circleView.layer.shadowColor = UIColor.black.cgColor
        circleView.layer.shadowOpacity = 0.5
        circleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        circleView.layer.shadowRadius = 2
        circleView.center = view.center
        view.addSubview(circleView)
        
        // Add a gradient background to the circle view
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = circleView.bounds
//        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
//        circleView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Add separator lines to the circle
        let separatorLayer = CAShapeLayer()
        separatorLayer.strokeColor = UIColor.white.cgColor
        separatorLayer.lineWidth = 0.5
        let path = UIBezierPath()
        for i in 0..<options.count {
            let radius: CGFloat = 125
            let lineLength: CGFloat = 0.1
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
            wordLabel.textColor = UIColor.init(white: 4, alpha: 0.5)
            wordLabel.font = UIFont.systemFont(ofSize: wordLabelFontSize, weight: .bold)
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
        // Display a random saying while the wheel is spinning
        let sayingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        sayingLabel.center.y = circleView.center.y + 200
        sayingLabel.font = UIFont.systemFont(ofSize: 20)
        sayingLabel.textColor = UIColor.white
        sayingLabel.textAlignment = .center
        sayingLabel.text = sayings.randomElement()
        view.addSubview(sayingLabel)

        UIView.animate(withDuration: 5.0, delay: 0, options: .curveEaseInOut, animations: {
            sayingLabel.alpha = 0
        }, completion: { _ in
            sayingLabel.removeFromSuperview()
        })

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


    
    
