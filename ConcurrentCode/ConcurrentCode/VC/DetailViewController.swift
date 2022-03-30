import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Properties
    
    private let uri = "https://clipart-best.com/img/mario/mario-clip-art-5.png"
    private var people = [Hero]()
    private let service: SWApiServiceProtocol = SWApiService(endpointService: EndpointService())
    
    // MARK: @IBOutlet views properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! {
        didSet {
            loadingIndicator.isHidden = true
            loadingIndicator.hidesWhenStopped = true
        }
    }
    
    // MARK: VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       pagePrepare()
    }
    
    // MARK: Private
    
    private func pagePrepare() {
        // Execute image downloading first
        let imageGroup = DispatchGroup()
        imageGroup.enter()
        fetchImage()
        imageGroup.leave()
        
        //Execute heroes from api after image downloading
        imageGroup.notify(queue: .global(qos: .utility)) {
            self.service.getPeople { [weak self] heroes in
                heroes.results?.forEach {
                    self?.people.append($0)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func fetchImage() {
        guard let url = URL(string: uri) else { return }
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            guard
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
            else { self.loadingIndicator.stopAnimating() ; return }
            DispatchQueue.main.async {
                self.imageView.image = image
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row].name
        cell.detailTextLabel?.text = people[indexPath.row].gender
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
}
