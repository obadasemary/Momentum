// ── FILE: Packages/Domain/Tests/DomainTests/ToDoEdgeCasesTests.swift ──

import Testing
import Foundation
@testable import Domain

@Suite("ToDoUseCase Edge Cases")
struct ToDoEdgeCasesTests {

    @Test("Create with very long title succeeds")
    func createWithVeryLongTitle() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)
        let longTitle = String(repeating: "a", count: 1000)

        let todo = try await sut.create(title: longTitle, notes: nil)
        #expect(todo.title.count == 1000)
    }

    @Test("Create with special characters in title succeeds")
    func createWithSpecialCharacters() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)
        let title = "Task !@#$%^&*()_+-=[]{}|;':\",./<>?"

        let todo = try await sut.create(title: title, notes: nil)
        #expect(todo.title == title)
    }

    @Test("Create with emoji in title succeeds")
    func createWithEmoji() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Buy groceries 🛒", notes: nil)
        #expect(todo.title == "Buy groceries 🛒")
    }

    @Test("Create with nil notes stores nil")
    func createWithNilNotesStoresNil() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)
        #expect(todo.notes == nil)
    }

    @Test("Create with empty notes stores empty string")
    func createWithEmptyNotesStoresEmptyString() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: "")
        #expect(todo.notes == "")
    }

    @Test("Todo created date is set within test window")
    func todoCreatedDateIsWithinWindow() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let before = Date()
        let todo = try await sut.create(title: "Task", notes: nil)
        let after = Date()

        #expect(todo.createdAt >= before)
        #expect(todo.createdAt <= after)
    }

    @Test("Completion date is set when toggled to complete")
    func completionDateSetWhenToggled() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)
        let before = Date()
        try await sut.toggleCompletion(todo.id)
        let after = Date()

        let todos = try await sut.fetchAll()
        let completedAt = try #require(todos.first?.completedAt)
        #expect(completedAt >= before)
        #expect(completedAt <= after)
    }

    @Test("Completion date cleared when toggled back to incomplete")
    func completionDateClearedWhenToggledBack() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)
        try await sut.toggleCompletion(todo.id)
        try await sut.toggleCompletion(todo.id)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.completedAt == nil)
    }

    @Test("Update notes to nil succeeds")
    func updateNotesToNil() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        var todo = try await sut.create(title: "Task", notes: "Original notes")
        todo.notes = nil
        try await sut.update(todo)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.notes == nil)
    }
}
