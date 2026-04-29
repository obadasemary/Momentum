enum MappingError: Error, Sendable {
    case invalidURL(String)
    case missingField(String)
}
