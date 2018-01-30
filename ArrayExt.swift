
import Foundation

extension Array where Element == String {
    
    /// Sort by last name first, if no last name, sort by first name
    ///
    /// - Returns: sorted string array
    func sortedDancerNames() -> [String] {
        return self.sorted { (a, b) -> Bool in
            
            var aLast = String()
            var bLast = String()
            
            var aFirst = String()
            var bFirst = String()
            
            let aComp = a.components(separatedBy: " ")
            if let name = aComp.last {
                if aComp.count > 1 {
                    aLast = name
                } else if aComp.count > 0 {
                    aFirst = name
                }
            }
            
            let bComp = b.components(separatedBy: " ")
            if let name = bComp.last {
                if bComp.count > 1 {
                    bLast = name
                } else {
                    bFirst = name
                }
            }
            
            let nameA = !aLast.isEmpty ? aLast : aFirst
            let nameB = !bLast.isEmpty ? bLast : bFirst
            
            return nameA < nameB
        }
    }
}

extension Array where Element == OrganiserEvent {
    func sortByStartDate() -> [OrganiserEvent] {
        return self.sorted(by: { (eventA, eventB) -> Bool in
            if let eventAStart = eventA.runsFrom?.startOfDay, let eventBStart = eventB.runsFrom?.startOfDay {
                return eventAStart < eventBStart
            }
            return false
        })
    }
    
    func sortByName() -> [OrganiserEvent] {
        return self.sorted(by: { (eventA, eventB) -> Bool in
            if let eventAName = eventA.name?.uppercased().first, let eventBName = eventB.name?.uppercased().first {
                return eventAName < eventBName
            }
            return false
        })
    }
}
