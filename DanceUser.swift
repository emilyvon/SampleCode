import Parse

struct DanceUser {
    
    static let tableName = "_User"
    
    enum Field: String {
        case email
        case firstName
        case lastName
        case gender
        case photo
        case dateOfBirth
        case password
        case description
    }
    
    static var current: PFUser? {
        return PFUser.current()
    }
}

extension PFUser {
    
    var firstName: String? {
        get {
            return self[DanceUser.Field.firstName.rawValue] as? String
        }
        set {
            self[DanceUser.Field.firstName.rawValue] = newValue ?? NSNull() // Parse requires an `NSNull()` insteal of a `nil`
        }
    }
    
    var lastName: String? {
        get {
            return self[DanceUser.Field.lastName.rawValue] as? String
        }
        set {
            self[DanceUser.Field.lastName.rawValue] = newValue ?? NSNull()
        }
    }
    
    var fullName: String {
        return "\(firstName ?? String()) \(lastName ?? String())"
    }
    
    var gender: GenderType? {
        get {
            return GenderType.getType(named: self[DanceUser.Field.gender.rawValue] as? String ?? String())
        }
        set {
            self[DanceUser.Field.gender.rawValue] = newValue?.rawValue ?? GenderType.notDisclosed.rawValue
        }
    }
    
    var userDescription: DescriptionType? {
        get {
            return DescriptionType.getType(named: self[DanceUser.Field.description.rawValue] as? String ?? String())
        }
        set {
            self[DanceUser.Field.description.rawValue] = newValue?.rawValue ?? NSNull()
        }
    }
    
    var dateOfBirth: Date? {
        get {
            return self[DanceUser.Field.dateOfBirth.rawValue] as? Date
        }
        set {
            self[DanceUser.Field.dateOfBirth.rawValue] = newValue ?? NSNull()
        }
    }
    
    var photo: PFFile? {
        get {
            return self[DanceUser.Field.photo.rawValue] as? PFFile
        }
        set {
            self[DanceUser.Field.photo.rawValue] = newValue ?? NSNull()
        }
    }
}

extension Data {
    var pfFile: PFFile? {
        return PFFile(name: "profileImage.jpeg", data: self) 
    }
}
