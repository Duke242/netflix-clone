import UIKit

// ViewController that displays upcoming movies
class UpcomingViewController: UIViewController {
    
    // Array to hold the list of titles fetched from the API
    private var titles: [Title] = [Title]()
    
    // TableView to display the list of upcoming movies
    private let upcomingTable: UITableView = {
        let table = UITableView()
        // Register a custom cell to use in the table view
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    // Called when the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the background color of the view
        view.backgroundColor = .systemBackground
        // Set the title of the view controller
        title = "Upcoming"
        // Enable large titles in the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        // Always display large titles for this view controller
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // Add the table view to the main view
        view.addSubview(upcomingTable)
        // Set the delegate and data source for the table view
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        // Fetch the list of upcoming movies from the API
        fetchUpcoming()
    }
    
    // Called when the view's subviews need to be laid out
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set the table view's frame to match the bounds of the main view
        upcomingTable.frame = view.bounds
    }
    
    // Function to fetch upcoming movies from the API
    private func fetchUpcoming(){
        // Call the API to get upcoming movies
        APICaller.shared.getUpcomingMovies { [weak self] result in
            // Handle the result of the API call
            switch result {
            case .success(let titles):
                // If successful, update the titles array with the fetched data
                self?.titles = titles
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
                
            case .failure(let error):
                // If there's an error, print it
                print(error.localizedDescription)
            }
        }
    }
}

// Extension to handle UITableViewDelegate and UITableViewDataSource methods
extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Return the number of rows in the table view (number of titles)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    // Configure each cell in the table view with title data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        // Configure the cell with the title's name and poster URL
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown Title Name", posterURL: title.poster_path ?? "No poster"))
        return cell
    }
    
    // Set the height for each row in the table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // Handle the event when a row is selected in the table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row with animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        // Get the title's name, either the original title or original name
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        // Call the API to get detailed information about the selected movie
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            // Handle the result of the API call
            switch result {
            case .success(let videoElement):
                // If successful, create a new view controller to display the movie's preview
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    // Configure the preview view controller with the title, YouTube video, and overview
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    // Push the preview view controller onto the navigation stack
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                // If there's an error, print it
                print(error.localizedDescription)
            }
        }
    }
}
