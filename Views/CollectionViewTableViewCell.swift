
import UIKit

// Protocol to handle cell tap events
protocol CollectionViewTableViewCellDelegate: AnyObject {
    // Method to notify when a cell is tapped
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    // Static identifier for cell reuse
    static let identifier = "CollectionViewTableViewCell"
    
    // Delegate to communicate cell events
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    // Array to hold titles
    private var titles: [Title] = [Title]()
    
    // Private UICollectionView property with a closure for setup
    private let collectionView: UICollectionView = {
        
        // Create a UICollectionViewFlowLayout for layout customization
        let layout = UICollectionViewFlowLayout()
        // Set item size for the collection view cells
        layout.itemSize = CGSize(width: 140, height: 200)
        // Set scroll direction to horizontal
        layout.scrollDirection = .horizontal
        // Initialize UICollectionView with the layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // Register a custom cell for reuse
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    // Custom initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Set background color for the cell's content view
        contentView.backgroundColor = .systemPink
        // Add collection view as a subview of the content view
        contentView.addSubview(collectionView)
        
        // Set the delegate and data source for the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // Required initializer (not implemented, will crash if called)
    required init(coder: NSCoder) {
        fatalError()
    }
    
    // Layout subviews to match the cell's content view bounds
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the frame of the collection view to fill the content view
        collectionView.frame = contentView.bounds
    }
    
    // Configure the cell with an array of titles
    public func configure(with titles: [Title]){
        self.titles = titles
        // Reload the collection view data on the main thread
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // Download title at a specific index path
    private func downloadTitleAt(indexPath: IndexPath) {
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            switch result {
            case .success():
                // Post a notification when download is successful
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                // Print error description if download fails
                print(error.localizedDescription)
            }
        }
    }
}

// Extension to conform to UICollectionViewDelegate and UICollectionViewDataSource protocols
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Provide a cell for each item in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue reusable cell and cast it to TitleCollectionViewCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // Ensure the title has a poster path
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        // Configure the cell with the poster path
        cell.configure(with: model)
        
        return cell
    }
    
    // Define the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    // Handle item selection in the collection view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Deselect the item after selection
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // Get the selected title and its name
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        // Fetch the movie trailer from the API
        APICaller.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                // Print video element ID for debugging
                print(videoElement.id)
                
                // Get title overview
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                // Create a view model with title details
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                // Notify delegate about the cell tap
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                
            case .failure(let error):
                // Print error description if API call fails
                print(error.localizedDescription)
            }
        }
    }
    
    // Provide a context menu for items in the collection view
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        // Create a context menu configuration
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                // Create a "Download" action
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    // Handle download action
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                // Return the menu with the download action
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        
        return config
    }
}
