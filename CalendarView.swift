
import UIKit
import FSCalendar

protocol CalendarViewDelegate {
    func didSelectOrganiserEvent(event: OrganiserEvent)
    func didSelectUserEvent(event: UserEvent)
    func dismiss()
}

class CalendarView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: CalendarViewDelegate?
    
    var filteredOrganiserEvents = [OrganiserEvent]()
    var filteredUserEvents = [UserEvent]()
    
    var filteredUserEventsCount: Int {
        return filteredUserEvents.count
    }
    
    var filteredOrganiserEventsCount: Int {
        return filteredOrganiserEvents.count
    }
    
    var userAndOrgExist: Bool {
        return filteredUserEventsCount > 0 && filteredOrganiserEventsCount > 0
    }
    
    var userOnlyExists: Bool {
        return filteredUserEventsCount > 0 && filteredOrganiserEventsCount <= 0
    }
    
    var orgOnlyExists: Bool {
        return filteredOrganiserEventsCount > 0 && filteredUserEventsCount <= 0
    }
    
    static let nibId = "CalendarView"
    
    var isMultipleEventType = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        self.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        
        tableView.register(UINib(nibName: CalendarTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: CalendarTableViewCell.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        goToToday()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: CalendarView.nibId, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction func todayButtonTapped(_ sender: Any) {
        goToToday()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.dismiss()
    }
    
    private func goToToday() {
        let today = Date()
        calendar.select(Date())
        displayEvent(for: today)
    }
    
    func displayEvent(for date: Date) {
        if isMultipleEventType {
            
            if let allUserEvents = SessionManager.shared.userEvents,
                let filteredResults = Helper.getUserEvents(from: allUserEvents, on: date) {
                filteredUserEvents = filteredResults
            }
            
            if let allOrganiserEvents = SessionManager.shared.organiserEventsForCurrentUser,
                let filteredResults = Helper.getOrganiserEvents(from: allOrganiserEvents, on: date) {
                filteredOrganiserEvents = filteredResults.sortByName().sortByStartDate()
            }
            
        } else {
            
            if let allEvents = SessionManager.shared.organiserEvents,
                let filteredResults = Helper.getOrganiserEvents(from: allEvents, on: date) {
                filteredOrganiserEvents = filteredResults.sortByName().sortByStartDate()
            }
            
        }
        tableView.reloadData()
    }
}

// MARK: - FSCalendarDataSource
extension CalendarView: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if isMultipleEventType {
            var eventCount = 0
            
            if let userEvents = SessionManager.shared.userEvents,
                let filtered = Helper.getUserEvents(from: userEvents, on: date) {
                eventCount += filtered.count
            }
            
            if let orgEvents = SessionManager.shared.organiserEventsForCurrentUser,
                let filtered = Helper.getOrganiserEvents(from: orgEvents, on: date) {
                eventCount += filtered.count
            }
            
            return eventCount
            
        } else {
            if let events = SessionManager.shared.organiserEvents, let filtered = Helper.getOrganiserEvents(from: events, on: date) {
                return filtered.count
            }
        }
        return 0
    }
}

// MARK: - FSCalendarDelegate
extension CalendarView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        displayEvent(for: date)
    }
}

// MARK: - UITableViewDataSource
extension CalendarView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 0
        if isMultipleEventType {
            if filteredUserEvents.count > 0 {
                sectionCount += 1
            }
            if filteredOrganiserEvents.count > 0 {
                sectionCount += 1
            }
        } else {
            if filteredOrganiserEvents.count > 0 {
                sectionCount += 1
            }
        }
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMultipleEventType {
            if userAndOrgExist {
                return section == 0 ? filteredUserEventsCount : filteredOrganiserEventsCount
            } else if userOnlyExists {
                return filteredUserEventsCount
            } else if orgOnlyExists {
                return filteredOrganiserEventsCount
            } else {
                return 0
            }
        } else {
            return filteredOrganiserEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = Bundle.main.loadNibNamed(CalendarTableViewCell.cellIdentifier, owner: self, options: nil)?.first as? CalendarTableViewCell {
            
            if isMultipleEventType {
                
                if userAndOrgExist {
                    if indexPath.section == 0 {
                        cell.configCell(userEvent: filteredUserEvents[indexPath.row])
                    } else {
                        cell.configCell(organiserEvent: filteredOrganiserEvents[indexPath.row])
                    }
                } else if userOnlyExists {
                    cell.configCell(userEvent: filteredUserEvents[indexPath.row])
                } else if orgOnlyExists  {
                    cell.configCell(organiserEvent: filteredOrganiserEvents[indexPath.row])
                }
            } else {
                cell.configCell(organiserEvent: filteredOrganiserEvents[indexPath.row])
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isMultipleEventType {
            let userEventsTitle = "User Events"
            let orgEventsTitle = "Organiser Events"
            if userAndOrgExist {
                return section == 0 ? userEventsTitle : orgEventsTitle
            } else if userOnlyExists {
                return userEventsTitle
            } else if orgOnlyExists {
                return orgEventsTitle
            }
        } else {
            if filteredOrganiserEvents.count > 0 {
                return "Organiser Events"
            }
        }
        return nil
    }
}

// MARK: - UITableViewDelegate
extension CalendarView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMultipleEventType {
            if userAndOrgExist {
                if indexPath.section == 0 {
                    delegate?.didSelectUserEvent(event: filteredUserEvents[indexPath.row])
                } else {
                    delegate?.didSelectOrganiserEvent(event: filteredOrganiserEvents[indexPath.row])
                }
            } else if userOnlyExists {
                delegate?.didSelectUserEvent(event: filteredUserEvents[indexPath.row])
            } else if orgOnlyExists {
                delegate?.didSelectOrganiserEvent(event: filteredOrganiserEvents[indexPath.row])
            }
        } else {
            delegate?.didSelectOrganiserEvent(event: filteredOrganiserEvents[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
}
