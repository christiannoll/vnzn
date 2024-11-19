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
    @MainActor
    func updateDataInDatabase(modelContext: ModelContext) async {
        /*do {
            let itemData: [ItemDTO] = try await fetchData(fromUrl: "https://jsonplaceholder.typicode.com/albums/1/photos")
            for eachItem in itemData {
                let itemToStore = PhotoObject(item: eachItem)
                modelContext.insert(itemToStore)
            }
        } catch {
            print("Error fetching data")
            print(error.localizedDescription)
        }*/
    }

    func fetchData(fromUrl: String) async throws -> String {
        guard let downloadedData: String = await Client().downloadData(fromURL: fromUrl) else {return ""}

        return downloadedData
    }
    
    private func downloadData(fromURL: String) async -> String? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            let configuration = URLSessionConfiguration.default
            //configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
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
