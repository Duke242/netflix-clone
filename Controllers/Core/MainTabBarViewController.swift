import UIKit

// This class represents the main tab bar controller of the app.
// It manages the different tabs and their corresponding view controllers.
class MainTabBarViewController: UITabBarController {

    // This method is called after the view controller has loaded its view hierarchy into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color of the view to a system-defined yellow color.
        view.backgroundColor = .systemYellow
        
        // Create a UINavigationController for each tab, with a root view controller.
        // The UINavigationController allows for navigation between different views within each tab.
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        // Set the tab bar icon for each view controller using system-provided icons.
        vc1.tabBarItem.image = UIImage(systemName: "house") // Home tab
        vc2.tabBarItem.image = UIImage(systemName: "play.circle") // Coming Soon tab
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass") // Search tab
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line") // Downloads tab
        
        // Set the title of each tab, which will be displayed below the icon.
        vc1.title = "Home"
        vc2.title = "Coming Soon"
        vc3.title = "Search"
        vc4.title = "Downloads"
        
        // Set the tint color of the tab bar items (i.e., the icon and title color when selected).
        tabBar.tintColor = .label
        
        // Add the view controllers to the tab bar controller.
        // The array defines the order in which the tabs will appear.
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}
