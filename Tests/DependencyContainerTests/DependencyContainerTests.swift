import Testing
@testable import DependencyContainer

// MARK: - Test Helpers

private protocol ServiceProtocol {
    var name: String { get }
}

private struct MockService: ServiceProtocol {
    let name: String
}

private struct AnotherService {
    let value: Int
}

// MARK: - Tests

@MainActor
struct DependencyContainerTests {

    // MARK: - Protocol Conformance

    @Test
    func conformsToDependencyContainerProtocol() {
        let container: any DependencyContainerProtocol = DependencyContainer()
        #expect(container is DependencyContainer)
    }

    // MARK: - Register & Resolve

    @Test
    func registerAndResolveInstance() {
        let container = DependencyContainer()
        let service = MockService(name: "test")

        container.register(MockService.self, service: service)
        let resolved = container.resolve(MockService.self)

        #expect(resolved?.name == "test")
    }

    @Test
    func registerAndResolveWithFactory() {
        let container = DependencyContainer()

        container.register(MockService.self, factory: {
            MockService(name: "factory")
        })
        let resolved = container.resolve(MockService.self)

        #expect(resolved?.name == "factory")
    }

    // MARK: - Resolve Unregistered

    @Test
    func resolveUnregisteredTypeReturnsNil() {
        let container = DependencyContainer()
        let resolved = container.resolve(MockService.self)

        #expect(resolved == nil)
    }

    // MARK: - Override

    @Test
    func registerSameTypeOverridesPrevious() {
        let container = DependencyContainer()

        container.register(MockService.self, service: MockService(name: "first"))
        container.register(MockService.self, service: MockService(name: "second"))
        let resolved = container.resolve(MockService.self)

        #expect(resolved?.name == "second")
    }

    // MARK: - Multiple Types

    @Test
    func registerAndResolveDifferentTypes() {
        let container = DependencyContainer()

        container.register(MockService.self, service: MockService(name: "mock"))
        container.register(AnotherService.self, service: AnotherService(value: 42))

        let mockResolved = container.resolve(MockService.self)
        let anotherResolved = container.resolve(AnotherService.self)

        #expect(mockResolved?.name == "mock")
        #expect(anotherResolved?.value == 42)
    }
}
