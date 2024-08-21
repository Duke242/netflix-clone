//
//  HeroHeaderUIView.swift
//  netflix-clone
//
//  Created by Duke 0 on 8/19/24.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    // Create a download button
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    // Create a play button
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    // Private UIImageView property with a closure
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        // Set the content mode to scale and fill the image view
        imageView.contentMode = .scaleAspectFill
        // Enable clipping to bounds to prevent image from overflowing
        imageView.clipsToBounds = true
        // Set the image to a named image in the asset catalog
        imageView.image = UIImage(named: "monteCristo")
        return imageView
    }()
    
    // Private method to add a gradient overlay
    private func addGradient() {
        // Create a CAGradientLayer
        let gradientLayer = CAGradientLayer()
        // Set the colors for the gradient (clear to system background)
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        // Set the frame of the gradient to match the view's bounds
        gradientLayer.frame = bounds
        
        // Add the gradient layer to the view's layer
        layer.addSublayer(gradientLayer)
    }
    
    // Custom initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        // Add the play and download buttons as subviews
        addSubview(playButton)
        addSubview(downloadButton)
        // Apply constraints to position the buttons
        applyConstraints()
    }
    
    // Method to apply constraints to the buttons
    private func applyConstraints() {
        // Define constraints for the play button
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        // Define constraints for the download button
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        // Activate all the constraints
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else {return}
        
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    // Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the frame of the hero image view to match the view's bounds
        heroImageView.frame = bounds
    }
    
    // Required initializer (not implemented, will crash if called)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
