import Foundation

class CommonStorage<Element> {
    
    private var element: Element?
    private let queue = DispatchQueue(label: "com.ConcurrentCode.storageQueue", qos: .utility, attributes: .concurrent)
    
    // Using sync to get correct data
    func get() -> Element? {
        var copy: Element? = nil
        queue.sync {
            copy = element
        }
        return copy
    }
    
    // Using barier to allow only one thread change element
    func set(element: Element) {
        queue.async(flags: .barrier) {
            self.element = element
        }
    }
    
}
