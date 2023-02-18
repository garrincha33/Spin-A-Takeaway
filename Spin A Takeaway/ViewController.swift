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

class ViewController: UIViewController, UITableViewDelegate {
    
    let options = ["Italian", "Chinese", "Indian", "Thai", "Mexican", "Pizza", "Burger", "Sushi"]
    let sayings = ["Mmm...I wonder what you're having tonight.", "The suspense is hard to take.", "Feeling lucky?", "I'm excited to see what you get!", "Bon appetit!", "Personally, I love mexican"]
    let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let wordLabelFontSize: CGFloat = 20
    var selectedOption: String?
    let customFont = UIFont(name: "HuskyGiggleDEMO-Regular", size: 50)
    let cogButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        let cogImage = UIImage(systemName: "gearshape.fill", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        cogButton.frame = CGRect(x: view.frame.maxX - 60, y: 60, width: 30, height: 30)
        cogButton.setImage(cogImage, for: .normal)
        view.addSubview(cogButton)
        
        let logoImageView = UIImageView(image: UIImage(named: "bg2"))
        logoImageView.frame = CGRect(x: view.frame.maxX / 7, y: 25, width: 300, height: 250)
        view.addSubview(logoImageView)
        
        let spinWheelImageView = UIImageView(image: UIImage(named: "spinwheel"))
        spinWheelImageView.frame = CGRect(x: logoImageView.frame.midX - 123, y: logoImageView.frame.maxY - 15, width: 250, height: 50)
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
        
//        let separatorLayer = CAShapeLayer()
//        separatorLayer.strokeColor = UIColor.white.cgColor
//        separatorLayer.lineWidth = 0.5
//        separatorLayer.zPosition = 1
//        let path = UIBezierPath()
//        for i in 0..<options.count {
//            let radius: CGFloat = 125
//            let lineLength: CGFloat = 0.1
//            let angle = CGFloat(i) * (2 * CGFloat.pi / CGFloat(options.count))
//            let x = circleView.bounds.midX + (radius - lineLength) * cos(angle)
//            let y = circleView.bounds.midY + (radius - lineLength) * sin(angle)
//            let startPoint = CGPoint(x: circleView.bounds.midX, y: circleView.bounds.midY)
//            let endPoint = CGPoint(x: x, y: y)
//            let path = UIBezierPath()
//            path.move(to: startPoint)
//            path.addLine(to: endPoint)
//            separatorLayer.path = path.cgPath
//        }
//        separatorLayer.path = path.cgPath
//        circleView.layer.addSublayer(separatorLayer)
        
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
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        circleView.addGestureRecognizer(tapRecognizer)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.38, green: 0.71, blue: 0.80, alpha: 1.0).cgColor, UIColor(red: 0.91, green: 0.47, blue: 0.67, alpha: 1.0).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)

        let gradientLayerInside = CAGradientLayer()
        gradientLayerInside.frame = circleView.bounds
        gradientLayerInside.cornerRadius = gradientLayerInside.bounds.width / 2
        gradientLayerInside.colors = [UIColor(red: 0.38, green: 0.71, blue: 0.80, alpha: 1.0).cgColor, UIColor(red: 0.91, green: 0.47, blue: 0.67, alpha: 1.0).cgColor]
        circleView.layer.insertSublayer(gradientLayerInside, at: 0)
        
        cogButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
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
        
        view.isUserInteractionEnabled = false
        
        let numRotations = CGFloat(Int.random(in: 3...5))
        let finalAngle = numRotations * (2 * CGFloat.pi) + CGFloat.random(in: 0...(2 * CGFloat.pi))
        
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        spinAnimation.toValue = finalAngle
        spinAnimation.duration = 5.0
        spinAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        spinAnimation.isRemovedOnCompletion = false
        spinAnimation.fillMode = .forwards
        circleView.layer.add(spinAnimation, forKey: "spin")
        
        let wordAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        wordAnimation.toValue = -finalAngle
        wordAnimation.duration = 5.0
        wordAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        wordAnimation.isRemovedOnCompletion = false
        wordAnimation.fillMode = .forwards
        for subview in circleView.subviews {
            subview.layer.add(wordAnimation, forKey: "spin")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.view.isUserInteractionEnabled = true
            let selectedOptionIndex = Int(finalAngle / (2 * CGFloat.pi / CGFloat(self.options.count))) % self.options.count
            self.selectedOption = self.options[selectedOptionIndex]
            print("Selected option: \(self.selectedOption ?? "none")")
            let alert = UIAlertController(title: "Spin A Takeaway", message: "You should try \(self.selectedOption ?? "something else")!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.circleView.layer.removeAllAnimations()
            for subview in self.circleView.subviews {
                subview.layer.removeAllAnimations()
            }
        }
    }
    
    @objc func showSettings() {
        let settingsVC = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsVC)
        present(navController, animated: true, completion: nil)
    }

}

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 34)
        ]
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)


        // Register the table view cell class
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Set up the table view
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        // Set up the section header curve
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 16))
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: headerView.bounds,
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: CGSize(width: 16, height: 16)).cgPath
        headerView.layer.mask = maskLayer
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let personImage = UIImage(systemName: "person.fill")
        let personImageView = UIImageView(image: personImage)
        personImageView.contentMode = .scaleAspectFit
        personImageView.tintColor = .systemGreen
        personImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        personImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = "Created by"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = .systemGray

        let detailLabel = UILabel()
        detailLabel.text = "Richard Price"
        detailLabel.font = UIFont.preferredFont(forTextStyle: .body)
        detailLabel.textColor = .black

        let stackView = UIStackView(arrangedSubviews: [personImageView, titleLabel, detailLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4

        cell.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16).isActive = true
        stackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        cell.backgroundColor = .white
        cell.accessoryType = .none

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6

        let label = UILabel()
        label.text = "General"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.sizeToFit()

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true

        return view
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

}





       

