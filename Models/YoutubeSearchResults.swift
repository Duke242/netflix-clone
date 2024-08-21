//
//  YoutubeSearchResults.swift
//  netflix-clone
//
//  Created by Duke 0 on 8/21/24.
//

import Foundation



struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
