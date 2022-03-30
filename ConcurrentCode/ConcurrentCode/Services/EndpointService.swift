import Foundation

protocol EndpointServiceProtocol {
    func create(endpoint: String) -> URL?
}

struct EndpointService: EndpointServiceProtocol {
    
    let baseUrl = "https://swapi.dev/api/"
    
    func create(endpoint: String) -> URL? {
        return URL(string: baseUrl + endpoint)
    }
}
