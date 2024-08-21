//
//  CollectionViewTableViewCell.swift
//  netflix-clone
//
//  Created by Duke 0 on 8/19/24.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()
    
    // Private UICollectionView property with a closure
    private let collectionView: UICollectionView = {
        
        // Create a UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        // Set the size for each item in the collection view
        layout.itemSize = CGSize(width: 140, height: 200)
        // Set the scroll direction to horizontal
        layout.scrollDirection = .horizontal
        // Initialize the collection view with the layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // Register a default UICollectionViewCell for reuse
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    // Custom initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Set the background color of the content view
        contentView.backgroundColor = .systemPink
        // Add the collection view as a subview
        contentView.addSubview(collectionView)
        
        // Set the delegate and data source for the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // Required initializer (not implemented, will crash if called)
    required init(coder: NSCoder) {
        fatalError()
    }
    
    // Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the frame of the collection view to match the content view's bounds
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title]){
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}

// Extension to conform to UICollectionViewDelegate and UICollectionViewDataSource protocols
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // Provide a cell for each item in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        
        return cell
    }
    
    // Define the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                print(videoElement.id)
                
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
