
import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell" // Unique identifier for cell reuse
    
    // Private UIImageView property to display the poster image
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // Scale image to fill the view
        return imageView
    }()
    
    // Custom initializer to set up the cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView) // Add posterImageView as a subview
    }
    
    // Required initializer (not implemented, will crash if called)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Layout subviews to ensure the posterImageView fills the content view
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds // Set frame to match contentView's bounds
    }
    
    // Method to configure the cell with a poster URL string
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else { return }
        // Set the image of the posterImageView using SDWebImage
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
