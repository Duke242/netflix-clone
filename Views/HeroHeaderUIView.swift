//
//  HeroHeaderUIView.swift
//  netflix-clone
//
//  Created by Duke 0 on 8/19/24.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    // Create a download button with specific properties
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal) // Set button title
        button.layer.borderColor = UIColor.white.cgColor // Set border color
        button.layer.borderWidth = 1 // Set border width
        button.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        button.layer.cornerRadius = 5 // Set corner radius
        return button
    }()
    
    // Create a play button with specific properties
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal) // Set button title
        button.layer.borderColor = UIColor.white.cgColor // Set border color
        button.layer.borderWidth = 1 // Set border width
        button.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        button.layer.cornerRadius = 5 // Set corner radius
        return button
    }()
    
    // Private UIImageView property with a closure for setup
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // Scale the image to fill the view
        imageView.clipsToBounds = true // Clip image to bounds of the view
        imageView.image = UIImage(named: "monteCristo") // Set default image
        return imageView
    }()
    
    // Private method to add a gradient overlay to the view
    private func addGradient() {
        let gradientLayer = CAGradientLayer() // Create a gradient layer
        gradientLayer.colors = [
            UIColor.clear.cgColor, // Start color (clear)
            UIColor.systemBackground.cgColor // End color (system background)
        ]
        gradientLayer.frame = bounds // Set gradient frame to match view's bounds
        layer.addSublayer(gradientLayer) // Add gradient layer to view's layer
    }
    
    // Custom initializer to set up the view
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView) // Add hero image view as a subview
        addGradient() // Add gradient overlay
        addSubview(playButton) // Add play button as a subview
        addSubview(downloadButton) // Add download button as a subview
        applyConstraints() // Apply constraints to buttons
    }
    
    // Method to apply Auto Layout constraints to buttons
    private func applyConstraints() {
        // Constraints for play button
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70), // Position 70 points from the leading edge
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50), // Position 50 points from the bottom edge
            playButton.widthAnchor.constraint(equalToConstant: 120) // Set button width to 120 points
        ]
        
        // Constraints for download button
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70), // Position 70 points from the trailing edge
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50), // Position 50 points from the bottom edge
            downloadButton.widthAnchor.constraint(equalToConstant: 120) // Set button width to 120 points
        ]
        
        // Activate all the constraints
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    // Method to configure the view with a TitleViewModel
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else { return }
        // Set the image of the heroImageView using SDWebImage
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    // Layout subviews to ensure the hero image view fills the view
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds // Set frame to match the view's bounds
    }
    
    // Required initializer (not implemented, will crash if called)
    required init?(coder: NSCoder) {
        fatalError()
    }
}
