import UIKit

// DownloadsViewController is a view controller that manages and displays a list of downloaded titles.
class DownloadsViewController: UIViewController {
    
    // Array to store the list of downloaded titles.
    private var titles: [TitleItem] = [TitleItem]()

    // UITableView for displaying the list of downloaded titles.
    private let downloadedTable: UITableView = {
        let table = UITableView()
        // Registering a custom cell class for the table view.
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting the background color of the view.
        view.backgroundColor = .systemBackground
        // Setting the title of the view controller.
        title = "Downloads"
        // Adding the table view to the view hierarchy.
        view.addSubview(downloadedTable)
        // Enabling large titles for the navigation bar.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // Setting the delegate and data source for the table view.
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        // Fetching the list of downloaded titles from local storage.
        fetchLocalStorageForDownload()
        // Observing for notifications about new downloads to refresh the list.
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }

    // Fetches the list of downloaded titles from local storage and updates the table view.
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingTitlesFromDataBase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                // Reloading the table view on the main thread after fetching the data.
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                // Printing the error message if fetching fails.
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Setting the frame of the table view to match the bounds of the view.
        downloadedTable.frame = view.bounds
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Returns the number of rows in the table view based on the number of titles.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    // Configures and returns a cell for the table view at the specified index path.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        // Gets the title for the current row and creates a view model for it.
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown Title Name", posterURL: title.poster_path ?? "No poster"))
        return cell
    }
    
    // Returns the height for each row in the table view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // Handles the editing of rows, such as deletion.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // Deletes the title from the local database.
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                // Removes the title from the array and updates the table view.
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
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
