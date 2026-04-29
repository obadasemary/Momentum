// ── FILE: Packages/Domain/Sources/Domain/Errors/ToDoErrors.swift ──

public enum ToDoUseCaseError: Error, Sendable {
    case emptyTitle
}

public enum ToDoRepositoryError: Error, Sendable {
    case notFound
}
