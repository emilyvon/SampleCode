
import Foundation
import Parse

class Organiser: PFObject, PFSubclassing {
    
    @NSManaged var facebook: String?
    @NSManaged var name: String
    @NSManaged var phone: String?
    @NSManaged var photo: PFFile?
    @NSManaged var instagram: String?
    @NSManaged var website: String?
    @NSManaged var email: String?
    
    enum Field: String {
        case facebook
        case name
        case phone
        case photo
        case instagram
        case website
        case email
        case description
    }
    
    override init() {
        super.init()
    }
    
    init(facebook: String? = nil, name: String, phone: String? = nil, photo: PFFile? = nil, instagram: String? = nil, website: String? = nil, email: String? = nil) {
        super.init()
        self.facebook = facebook
        self.name = name
        self.phone = phone
        self.photo = photo
        self.instagram = instagram
        self.website = website
        self.email = email
    }
    
    /// `description` is a reserved word in NSObject which is what PFObject inherits from, we can't use or override this property
    func getDescription() -> String {
        return self[Field.description.rawValue] as? String ?? String()
    }
   
    static func parseClassName() -> String {
        return "Organiser"
    }
}
