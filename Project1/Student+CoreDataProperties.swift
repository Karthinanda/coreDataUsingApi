

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?

}

extension Student : Identifiable {

}
