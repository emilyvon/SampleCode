
import UIKit

class EventSavedPopUpView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var addToCalendarButton: UIButton!
    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commontInit()
    }
    
    override func layoutSubviews() {
        addToCalendarButton.layer.cornerRadius = addToCalendarButton.frame.size.height / 2
        addEventButton.layer.cornerRadius = addEventButton.frame.size.height / 2
        dismissButton.layer.cornerRadius = dismissButton.frame.size.height / 2
    }
    
    private func commontInit() {
        Bundle.main.loadNibNamed("EventSavedPopUpView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.appGrey.cgColor
    }
}
