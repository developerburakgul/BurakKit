import Foundation

public protocol DependencyContainerProtocol: Sendable {
    @MainActor 
    func register<T>(_ type: T.Type, service: T)

    @MainActor 
    func register<T>(_ type: T.Type, factory: () -> T)
    
    func resolve<T>(_ type: T.Type) -> T?
}

public final class DependencyContainer: DependencyContainerProtocol {
    private let lock = NSLock()
    private nonisolated(unsafe) var services: [ObjectIdentifier: Any] = [:]

    public init() {}

    @MainActor
    public func register<T>(_ type: T.Type, service: T) {
        let key = ObjectIdentifier(type)
        lock.lock()
        services[key] = service
        lock.unlock()
    }

    @MainActor
    public func register<T>(_ type: T.Type, factory: () -> T) {
        let key = ObjectIdentifier(type)
        lock.lock()
        services[key] = factory()
        lock.unlock()
    }

    public func resolve<T>(_ type: T.Type) -> T? {
        let key = ObjectIdentifier(type)
        lock.lock()
        defer { lock.unlock() }
        return services[key] as? T
    }
}
