//
//  TitleTableViewCell.swift
//  netflix-clone
//
//  Created by Duke 0 on 8/20/24.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell" // Unique identifier for cell reuse
    
    // Create a play button with a system image
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)) // Set play icon
        button.setImage(image, for: .normal) // Set image for normal state
        button.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        button.tintColor = .white // Set tint color to white
        return button
    }()
    
    // Create a label to display the title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        return label
    }()
    
    // Create an image view for the title poster
    private let titlePosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // Scale image to fit the view
        imageView.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        imageView.clipsToBounds = true // Clip image to bounds of the view
        return imageView
    }()
    
    // Custom initializer to set up the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePosterUIImageView) // Add poster image view as a subview
        contentView.addSubview(titleLabel) // Add title label as a subview
        contentView.addSubview(playTitleButton) // Add play button as a subview
        
        applyConstraints() // Apply constraints to subviews
    }
     
    // Method to apply Auto Layout constraints to subviews
    private func applyConstraints() {
        // Constraints for the titlePosterUIImageView
        let titlePosterUIImageViewConstraints = [
            titlePosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), // Align with leading edge
            titlePosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // 10 points from top edge
            titlePosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10), // 10 points from bottom edge
            titlePosterUIImageView.widthAnchor.constraint(equalToConstant: 100) // Set width to 100 points
        ]
        
        // Constraints for the titleLabel
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterUIImageView.trailingAnchor, constant: 20), // 20 points from trailing edge of image view
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor) // Center vertically in content view
        ]
        
        // Constraints for the playTitleButton
        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20), // 20 points from trailing edge
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor) // Center vertically in content view
        ]
    
        // Activate all the constraints
        NSLayoutConstraint.activate(titlePosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    // Method to configure the cell with a TitleViewModel
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else { return }
        // Set the image of titlePosterUIImageView using SDWebImage
        titlePosterUIImageView.sd_setImage(with: url, completed: nil)
        // Set the text of titleLabel
        titleLabel.text = model.titleName
    }
    
    // Required initializer (not implemented, will crash if called)
    required init(coder: NSCoder) {
        fatalError()
    }

}
