import Foundation

protocol SWApiServiceProtocol {
    func getPeople(completion: @escaping (Heroes) -> ())
}

final class SWApiService: SWApiServiceProtocol {
    
    private let endpointService: EndpointServiceProtocol
    
    init(endpointService: EndpointServiceProtocol) {
        self.endpointService = endpointService
    }
    
    func getPeople(completion: @escaping (Heroes) -> ()) {
        
        guard let url = endpointService.create(endpoint: "people/") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let models = try? JSONDecoder().decode(Heroes.self, from: data)
            else { return }
            completion(models)
        }.resume()
    }
}
