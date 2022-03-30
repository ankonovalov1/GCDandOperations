import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Properties
    
    let uri = "https://clipart-best.com/img/mario/mario-clip-art-5.png"
    
    // MARK: @IBOutlet views properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! {
        didSet {
            loadingIndicator.isHidden = true
            loadingIndicator.hidesWhenStopped = true
        }
    }
    
    // MARK: VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    // MARK: Private
    
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

//extension UIImageView {
//
//    func fetchImage(url: URL?) {
//        let queue = DispatchQueue.global(qos: .utility)
//        queue.async {
//            guard
//                let url = url,
//                let data = try? Data(contentsOf: url),
//                let image = UIImage(data: data)
//            else { return }
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
//    }
//
//}
