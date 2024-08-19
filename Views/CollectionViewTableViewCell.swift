//
//  CollectionViewTableViewCell.swift
//  netflix-clone
//
//  Created by Duke 0 on 8/19/24.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    // Static identifier for cell reuse
    static let identifier = "CollectionViewTableViewCell"
    
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
}

// Extension to conform to UICollectionViewDelegate and UICollectionViewDataSource protocols
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // Provide a cell for each item in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a reusable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        // Set the background color of the cell
        cell.backgroundColor = .green
        return cell
    }
    
    // Define the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
