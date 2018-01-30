
import UIKit
import MessageUI

class ViewEventViewController: BaseEventViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    var userEvent: UserEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventNameLabel.text = userEvent.name
        tableView.reloadData()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: AddMyEventViewController.storyboardId) as! AddMyEventViewController
        vc.editingUserEvent = userEvent
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        if canDeviceSendEmail() {
            let userName = DanceUser.current?.firstName ?? String()
            let subject = "\(userName.isEmpty ? "Shared" : "\(userName)'s") Events"
            let body = Helper.fullEmailString(body: Helper.bodyString(with: Helper.getHtmlBodyString(from: userEvent)), screenWidth: emailHeaderImageSize)
            presentMailComposer(subject: subject, body: body)
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewEventViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 /* this number won't change */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ViewEventTableViewCell.cellIdentifier) as? ViewEventTableViewCell {
            cell.configCell(userEvent: userEvent, row: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewEventViewController: EmailHeaderImageSize { }
