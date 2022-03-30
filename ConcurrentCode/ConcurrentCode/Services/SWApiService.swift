import Foundation

protocol SWApiServiceProtocol {
    func getPeople(completion: @escaping (Heroes) -> ())
}

final class SWApiService: SWApiServiceProtocol {
    
    private let endpointService: EndpointServiceProtocol
    private let storage: CommonStorage<Heroes>
    
    init(endpointService: EndpointServiceProtocol) {
        self.endpointService = endpointService
        self.storage = CommonStorage()
    }
    
    func getPeople(completion: @escaping (Heroes) -> ()) {
        
        if let cache = storage.get() { completion(cache) }
        else {
            guard let url = endpointService.create(endpoint: "people/") else { return }
            
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                guard
                    let data = data,
                    let model = try? JSONDecoder().decode(Heroes.self, from: data)
                else { return }
                self.storage.set(element: model)
                completion(model)
            }
            .resume()
        }
       
    }
}
