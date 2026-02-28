import Foundation
import SwiftData

@Model
final class AccountabilityPartner {
    var id: UUID
    var name: String
    var phone: String
    var email: String
    var relationship: String
    var isPrimary: Bool
    var createdAt: Date
    var linkedStruggleID: UUID?

    init(
        name: String,
        phone: String = "",
        email: String = "",
        relationship: String = "",
        isPrimary: Bool = false,
        linkedStruggleID: UUID? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.phone = phone
        self.email = email
        self.relationship = relationship
        self.isPrimary = isPrimary
        self.createdAt = .now
        self.linkedStruggleID = linkedStruggleID
    }
}
