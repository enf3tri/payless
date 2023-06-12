import Foundation
import CoreData

@objc(Note)
class Note: NSManagedObject
{
    @NSManaged var id: NSNumber!
    @NSManaged var company: String!
    @NSManaged var date: String!
    @NSManaged var total: String!
    @NSManaged var deletedDate: Date?
    
    @NSManaged var totalEXP: String!

}
