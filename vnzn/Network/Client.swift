import Foundation
import SwiftData

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

class Client {

    func fetchRawData(fromURL: String) async -> Data? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print("Error fetching data: \(error)")
            return nil
        }
    }

    func fetchData(fromUrl: String) async throws -> String {
        guard let downloadedData: String = await Client().downloadData(fromURL: fromUrl) else {return ""}

        return downloadedData
    }
    
    private func downloadData(fromURL: String) async -> String? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            let urlSession = URLSession(configuration: configuration)
            
            let (data, response) = try await urlSession.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = String(data: data, encoding: .utf8) else { throw NetworkError.failedToDecodeResponse }
            
            return decodedResponse
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
        } catch {
            print("An error occured downloading the data")
        }
        
        return nil
    }
}
