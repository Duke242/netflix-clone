import UIKit

// Protocol to communicate with other parts of the app when an item is tapped
protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

// View controller for displaying search results
class SearchResultsViewController: UIViewController {
    
    // Array to hold the search results
    public var titles: [Title] = [Title]()
    
    // Delegate to handle item taps
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    // Collection view to display search results in a grid layout
    public let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        // Set item size to fit three items per row with a small margin
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0 // No spacing between items
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // Register custom cell class for the collection view
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground // Set background color
        view.addSubview(searchResultsCollectionView) // Add collection view to the view hierarchy
        
        // Set up delegate and data source for the collection view
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set the frame of the collection view to match the view's bounds
        searchResultsCollectionView.frame = view.bounds
    }
}

// Extension to conform to UICollectionViewDelegate and UICollectionViewDataSource
extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // Return the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    // Configure each cell with data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell() // Return a default cell if casting fails
        }
        
        // Configure the cell with the poster URL
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    // Handle item selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) // Deselect the item
        
        // Get the selected title
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        
        // Fetch movie details using the title name
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                // Notify the delegate about the item tap with the view model
                self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewViewModel(title: title.original_title ?? "", youtubeView: videoElement, titleOverview: title.overview ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription) // Print error if fetching movie details fails
            }
        }
    }
}
