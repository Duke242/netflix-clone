//
//  Extensions.swift
//  netflix-clone
//
//  Created by Duke 0 on 8/19/24.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
