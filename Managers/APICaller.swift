import Foundation

// Constants struct to store API keys and base URLs
struct Constants {
    static let API_KEY = "b21742a4882582b48285e3b3a6f1068b"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

// Custom error type for API-related errors
enum APIError: Error {
    case failedToGetData
}

// APICaller class to handle all API requests
class APICaller {
    // Singleton instance for global access
    static let shared = APICaller()
    
    // Function to fetch trending movies
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        // Construct the URL for the API request
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        // Create and start a data task for the network request
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            // Check if data is received and there's no error
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // Attempt to decode the JSON data into a TrendingTitleResponse object
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                // Pass the decoded results to the completion handler
                completion(.success(results.results))
            } catch {
                // If decoding fails, pass the error to the completion handler
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    // Function to fetch trending TV shows
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    // Function to fetch upcoming movies
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    // Function to fetch popular movies
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Function to fetch top-rated movies
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Function to discover movies
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Function to search for movies
    func search(with query: String,completion: @escaping (Result<[Title], Error>) -> Void) {
        // URL encode the query string
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}

        // Construct the URL with the encoded query
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // Function to get YouTube video information for a movie
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        // URL encode the query string
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        // Construct the YouTube API URL
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        
        // Create and start a data task for the network request
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // Attempt to decode the JSON data into a YoutubeSearchResponse object
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                // If decoding is successful, extract the first item from the results
                // and pass it to the completion handler as a success case
                completion(.success(results.items[0]))
            } catch {
                // If an error occurs during decoding, handle it in this block
                
                // Pass the error to the completion handler as a failure case
                completion(.failure(error))
                
                // Print the error description to the console for debugging purposes
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
