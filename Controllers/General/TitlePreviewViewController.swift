
import UIKit
import WebKit

// TitlePreviewViewController displays detailed information about a selected title, including a YouTube trailer, title, overview, and a download button.
class TitlePreviewViewController: UIViewController {
    
    // UILabel to display the title name.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry potter" // Placeholder text
        return label
    }()
    
    // UILabel to display the overview of the title.
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // Allows for multiple lines of text
        label.text = "This is the best movie ever to watch as a kid!" // Placeholder text
        return label
    }()
    
    // WKWebView to display the YouTube trailer of the title.
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // UIButton for downloading the title.
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red // Background color of the button
        button.setTitle("Download", for: .normal) // Button title
        button.setTitleColor(.white, for: .normal) // Title color
        button.layer.cornerRadius = 8 // Rounded corners
        button.layer.masksToBounds = true // Ensures the corners are rounded
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Adding subviews to the view hierarchy.
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        // Configures the layout constraints for the subviews.
        configureConstraints()
    }
    
    // Configures layout constraints for the subviews.
    func configureConstraints() {
        // Constraints for the web view.
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        // Constraints for the title label.
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ]
        
        // Constraints for the overview label.
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        // Constraints for the download button.
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        // Activates all constraints.
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    // Configures the view controller with data from a TitlePreviewViewModel.
    public func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title // Sets the title label text.
        overviewLabel.text = model.titleOverview // Sets the overview label text.
        
        // Creates a URL for the YouTube trailer.
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        
        // Loads the YouTube trailer in the web view.
        webView.load(URLRequest(url: url))
    }
}
