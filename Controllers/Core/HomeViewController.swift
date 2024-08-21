import UIKit


enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
    
    // Create a private UITableView property with a closure
    private let homeFeedTable: UITableView = {
        // Initialize a new UITableView with zero frame and grouped style
        let table = UITableView(frame: .zero, style: .grouped)
        // Register a custom cell class for reuse in the table
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color of the view
        view.backgroundColor = .systemBackground
        // Add the table view as a subview
        view.addSubview(homeFeedTable)
        
        // Set the delegate and data source for the table view
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        // Create and set a custom header view for the table
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView

        
    }
    
    private func configureNavbar() {
        // Load the Netflix logo image
        var image = UIImage(named: "netflixLogo")
        // Ensure the image is rendered as is, without any tint
        image = image?.withRenderingMode(.alwaysOriginal)
        // Set the left bar button item with the Netflix logo
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        // Set the right bar button items
        navigationItem.rightBarButtonItems = [
            // Add a 'person' icon button
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            // Add a 'play.rectangle' icon button
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        // Set the tint color of the navigation bar to white
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set the frame of the table view to match the view's bounds
        homeFeedTable.frame = view.bounds
    }
    
}
    // Extension to conform to UITableViewDelegate and UITableViewDataSource protocols
    extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
        
        // Define the number of sections in the table view
        func numberOfSections(in tableView: UITableView) -> Int {
            return sectionTitles.count
        }
        
        // Define the number of rows in each section
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        // Provide a cell for each row in the table view
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Dequeue a reusable cell and cast it to the custom cell type
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            
          
            switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                APICaller.shared.getTrendingMovies { result in
                    switch result {
                        
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
                
                
            case Sections.TrendingTv.rawValue:
                APICaller.shared.getTrendingTvs { result in
                    switch result {
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case Sections.Popular.rawValue:
                APICaller.shared.getPopular { result in
                    switch result {
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case Sections.Upcoming.rawValue:
                
                APICaller.shared.getUpcomingMovies { result in
                    switch result {
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            case Sections.TopRated.rawValue:
                APICaller.shared.getTopRated { result in
                    switch result {
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error)
                    }
                }
            default:
                return UITableViewCell()
            }
            
            return cell
        }
        
        // Set the height for each row
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200
        }
        
        // Set the height for the header in each section
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
        }
        
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            guard let header = view as? UITableViewHeaderFooterView else {return}
            header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y , width: 100, height: header.bounds.height)
            header.textLabel?.textColor = .white
            header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sectionTitles[section]
        }
        
        
        // Method called when the scroll view (table view in this case) is scrolled
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // Get the default offset, which is the top safe area inset
            let defaultOffset = view.safeAreaInsets.top
            // Calculate the total offset by adding the content offset and the default offset
            let offset = scrollView.contentOffset.y + defaultOffset
            
            // Transform the navigation bar based on the scroll offset
            // This creates a hiding effect for the navigation bar when scrolling down
            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        }
    }

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

