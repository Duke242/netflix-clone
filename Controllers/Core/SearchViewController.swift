import UIKit

// SearchViewController is a view controller responsible for displaying a list of titles (movies or TV shows) and handling search functionality.
class SearchViewController: UIViewController {
    
    // Array to hold the list of titles fetched from the API.
    private var titles: [Title] = [Title]()

    // UITableView for displaying the list of titles.
    private let discoverTable: UITableView = {
        let table = UITableView()
        // Registering a custom cell class for the table view.
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    // UISearchController to handle search functionality.
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        // Setting the placeholder text for the search bar.
        controller.searchBar.placeholder = "Search for a movie or a TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the title of the view controller.
        title = "Search"
        // Enabling large titles for the navigation bar.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // Adding the search controller to the navigation item.
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        // Setting the background color of the view.
        view.backgroundColor = .systemBackground
        
        // Adding the table view to the view hierarchy.
        view.addSubview(discoverTable)
        // Setting the delegate and data source for the table view.
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        // Fetching the list of discover movies.
        fetchDiscoverMovies()
        
        // Setting the search results updater.
        searchController.searchResultsUpdater = self
    }
    
    // Fetches discover movies from the API and updates the table view.
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                // Reloading the table view on the main thread after fetching the data.
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                // Printing the error message if the API call fails.
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Setting the frame of the table view to match the bounds of the view.
        discoverTable.frame = view.bounds
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    // Returns the number of rows in the table view based on the number of titles.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    // Configures and returns a cell for the table view at the specified index path.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeues a reusable cell and casts it to the custom cell class.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        // Gets the title for the current row and creates a view model for it.
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown name", posterURL: title.poster_path ?? "No poster")
        // Configures the cell with the view model.
        cell.configure(with: model)
        
        return cell
    }
    
    // Returns the height for each row in the table view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // Handles the selection of a row in the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Gets the title for the selected row.
        let title = titles[indexPath.row]
        
        // Retrieves the title name, ensuring it's not nil.
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        // Fetches additional details for the selected movie from the API.
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    // Creates and configures a view controller to display the movie details.
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    // Pushes the view controller onto the navigation stack.
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                // Prints the error message if the API call fails.
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating, SearchResultsViewControllerDelegate

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    // Updates the search results as the user types in the search bar.
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        // Checks if the search query is valid.
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                return
        }
        
        // Sets the delegate for the search results view controller.
        resultsController.delegate = self
        
        // Fetches search results from the API based on the query.
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    // Updates the search results view controller with the fetched titles.
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    // Prints the error message if the API call fails.
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Handles the tap event on an item in the search results.
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            // Creates and configures a view controller to display the details of the selected item.
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            // Pushes the view controller onto the navigation stack.
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
