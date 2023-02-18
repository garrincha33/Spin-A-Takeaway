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
    
    let sayings = ["Mmm...I wonder what you're having tonight.", "The suspense is hard to take.", "Feeling lucky?", "I'm excited to see what you get!", "Bon appetit!", "Personally, I love mexican"]

    let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let wordLabelFontSize: CGFloat = 20
    var selectedOption: String?
    
    let customFont = UIFont(name: "HuskyGiggleDEMO-Regular", size: 50)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for family in UIFont.familyNames {
//            print("Font family name: \(family)")
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("Font name: \(name)")
//            }
//        }
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        let cogImage = UIImage(systemName: "gearshape.fill", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let cogButton = UIButton(type: .system)
        cogButton.frame = CGRect(x: view.frame.maxX - 60, y: 60, width: 30, height: 30)
        cogButton.setImage(cogImage, for: .normal)
        view.addSubview(cogButton)

        
        let logoImageView = UIImageView(image: UIImage(named: "bg2"))
        logoImageView.frame = CGRect(x: view.frame.maxX / 7, y: 25, width: 300, height: 250)
        view.addSubview(logoImageView)
        
        // Add spinning wheel image view with flashing animation
        let spinWheelImageView = UIImageView(image: UIImage(named: "spinwheel"))
        spinWheelImageView.frame = CGRect(x: logoImageView.frame.midX - 80, y: logoImageView.frame.maxY + 120, width: 150, height: 50)
        spinWheelImageView.alpha = 0.0

        view.addSubview(spinWheelImageView)

        let flashAnimation = CABasicAnimation(keyPath: "opacity")
        flashAnimation.fromValue = 0.0
        flashAnimation.toValue = 1.0
        flashAnimation.duration = 0.5
        flashAnimation.autoreverses = true
        flashAnimation.repeatCount = .infinity
        spinWheelImageView.layer.add(flashAnimation, forKey: "flash")

        UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
            spinWheelImageView.alpha = 1.0
        }, completion: nil)


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
            let angle = CGFloat(i) * (2 * CGFloat.pi / CGFloat(options.count))
            let x = circleView.bounds.midX + radius * cos(angle)
            let y = circleView.bounds.midY + radius * sin(angle)
            let wordLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
            wordLabel.center = CGPoint(x: x, y: y)
            wordLabel.transform = CGAffineTransform(rotationAngle: angle)
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
        
        let gradientLayerInside = CAGradientLayer()
        gradientLayerInside.frame = circleView.bounds
        gradientLayerInside.cornerRadius = gradientLayerInside.bounds.width / 2
        gradientLayerInside.colors = [UIColor(red: 0.38, green: 0.71, blue: 0.80, alpha: 1.0).cgColor, UIColor(red: 0.91, green: 0.47, blue: 0.67, alpha: 1.0).cgColor]
        circleView.layer.insertSublayer(gradientLayerInside, at: 0)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Display a random saying while the wheel is spinning
        let sayingLabel = UILabel(frame: CGRect(x: 25, y: 50, width: 350, height: 250))
        sayingLabel.center.y = circleView.center.y + 200
        sayingLabel.font = customFont
        sayingLabel.textColor = UIColor.white
        sayingLabel.textAlignment = .center
        sayingLabel.text = sayings.randomElement()
        sayingLabel.numberOfLines = 0
        sayingLabel.lineBreakMode = .byWordWrapping
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





    
    
