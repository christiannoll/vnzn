import Foundation
import SwiftData
import OSLog

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

class Client {

    static private let dateFormatter = ISO8601DateFormatter()
    private let logger = Logger(subsystem: "de.vnzn.vnzn", category: "Client")

    static let shared = Client()
    private init() { }

    func fetchRawData(fromURL: String) async -> Data? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            logger.error("Error fetching data: \(error)")
            return nil
        }
    }

    func fetchData(fromUrl: String) async throws -> String {
        guard let downloadedData: String = await Client().downloadData(fromURL: fromUrl) else {return ""}

        return downloadedData
    }

    func fetchLastUpdate() async -> Double {
        let fromUrl = VnznEnv.baseUrl + "app/last_update.txt"
        return await fetchDate(fromUrl: fromUrl)
    }

    func fetchLastFullSync() async -> Double {
        let fromUrl = VnznEnv.baseUrl + "app/last_fullsync.txt"
        return await fetchDate(fromUrl: fromUrl)
    }

    private func fetchDate(fromUrl: String) async -> Double {
        do {
            let dateString = try await fetchData(fromUrl: fromUrl)
            return Self.dateFormatter.date(from: dateString)?.timeIntervalSince1970 ?? 0
        } catch {
            logger.error("[fetchDate] Error: \(error)")
            return 0
        }
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
            logger.error("There was an error creating the URL")
        } catch NetworkError.badResponse {
            logger.error("Did not get a valid response")
        } catch NetworkError.badStatus {
            logger.error("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse {
            logger.error("Failed to decode response into the given type")
        } catch {
            logger.error("An error occured downloading the data")
        }
        
        return nil
    }
}
