
import UIKit
import ParseUI

protocol ListEventsTableViewControllerDelegate {
    func didSelect(event: OrganiserEvent)
    func didSelect(organiser: Organiser)
    func didScrollTableView()
}

class ListEventsTableViewController: PFQueryTableViewController {
    
    var eventType: EventType!
    var organiserIdPassed: String?
    var listEventsTableViewControllerDelegate: ListEventsTableViewControllerDelegate?
    
    var eventList:[EventType] = []
    var localityList: [LocalityType] = []
    var fromDate: Date!
    var toDate: Date!
    var searchAllText: String?
    
    var organiserSearchText: String?
    
    private let tableViewHeight: CGFloat = 71
    
    /// search text ignoring cases
    private let caseInsensitiveModifier = "i"
    
    private var isOrganiser: Bool {
        return eventType == .organiser
    }
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        objectsPerPage = 20 // default is 25
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: EventsTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: EventsTableViewCell.cellIdentifier)
    }
    
    override func queryForTable() -> PFQuery<PFObject> {
        
        let query = PFQuery(className: isOrganiser ? Organiser.parseClassName() : OrganiserEvent.parseClassName())
        
        if let orgSearchTxt = self.organiserSearchText {
            query.whereKey(Organiser.Field.name.rawValue, matchesRegex: orgSearchTxt, modifiers: caseInsensitiveModifier)
            query.order(byAscending: OrganiserEvent.Field.name.rawValue)
            
        } else {
            
            if eventType == .all {
                
                if let orgId = organiserIdPassed {
                    // This is coming from viewing a particular organiser's all events
                    if self.objects!.count == 0 {
                        query.cachePolicy = .cacheThenNetwork
                    }
                    
                    let organiserPointer = PFObject(withoutDataWithClassName: Organiser.parseClassName(), objectId: orgId)
                    
                    query.order(byAscending: OrganiserEvent.Field.runsFrom.rawValue)
                    query.whereKey(OrganiserEvent.Field.organiser.rawValue, equalTo: organiserPointer)
                    
                } else {
                    // This is coming from the Search screen
                    
                    // Filter by Search Text
                    if let searchTxt = searchAllText, !searchTxt.isEmpty {
                        query.whereKey(OrganiserEvent.Field.name.rawValue, matchesRegex: searchTxt, modifiers: caseInsensitiveModifier)
                    }
                    
                    // Filter by Event Type
                    let eventCriteria = eventList.isEmpty ? EventType.listValidTypes : eventList
                    query.whereKey(OrganiserEvent.Field.type.rawValue, containedIn: eventCriteria.map { $0.nameDB })
                    
                    // Filter by Locality Type
                    let localityCriteria = localityList.count == 0 || localityList.contains(.all) ? LocalityType.listValidTypes : localityList
                    query.whereKey(OrganiserEvent.Field.state.rawValue, containedIn: localityCriteria.map { $0.nameDB })
                    
                    // Filter by Date
                    query.whereKey(OrganiserEvent.Field.runsFrom.rawValue, greaterThanOrEqualTo: fromDate)
                    query.whereKey(OrganiserEvent.Field.runsTo.rawValue, lessThanOrEqualTo: toDate)
                    
                    // Order by runsFrom
                    query.order(byAscending: OrganiserEvent.Field.runsFrom.rawValue)
                }
            } else {
                // This is coming from Competitions, Workshops, Festivals or Organisers on EventsViewController
                
                if self.objects!.count == 0 {
                    query.cachePolicy = .cacheThenNetwork
                }
                
                if isOrganiser {
                    query.order(byAscending: OrganiserEvent.Field.name.rawValue)
                } else {
                    query.order(byAscending: OrganiserEvent.Field.runsFrom.rawValue)
                    query.whereKey(OrganiserEvent.Field.type.rawValue, equalTo: eventType.nameDB)
                }
            }
        }
        return query
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell? {
        var cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.cellIdentifier) as? EventsTableViewCell
        if cell == nil {
            cell = EventsTableViewCell(style: .default, reuseIdentifier: EventsTableViewCell.cellIdentifier)
        }
        cell?.configCell(object: object)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt: \(indexPath.row)")
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if let eventObjects = objects as? [OrganiserEvent] {
            if indexPath.row < eventObjects.count { // last row is for displaying `Load more...`, not actionable
                listEventsTableViewControllerDelegate?.didSelect(event: eventObjects[indexPath.row])
            }
        } else if let organiserObjects = objects as? [Organiser] {
            if indexPath.row < organiserObjects.count { // last row is for displaying `Load more...`, not actionable
                listEventsTableViewControllerDelegate?.didSelect(organiser: organiserObjects[indexPath.row])
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listEventsTableViewControllerDelegate?.didScrollTableView()
    }
}
