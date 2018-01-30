
import UIKit

protocol AddDancerNameDelegate {
    func added(name: String, containerView: AddDancerNamePopUpView)
}

class AddDancerNamePopUpView: UIView, UITextFieldDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: AddDancerNameDelegate?
    var nameToAdd = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commontInit()
    }
    
    private func commontInit() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        
        alpha = 0
        
        addButton.alpha = 0.5
        addButton.isEnabled = false
        
        frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        }
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddDancerNamePopUpView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override func layoutSubviews() {
        addButton.layer.cornerRadius = addButton.frame.size.height / 2
        cancelButton.layer.cornerRadius = cancelButton.frame.size.height / 2
        cancelButton.borderColor = UIColor.appGrey
        cancelButton.borderWidth = 1
    }
    
    func dismiss() {
        nameTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
        }) { (done) in
            if done {
                self.removeFromSuperview()
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.added(name: nameToAdd.capitalized, containerView: self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: contentView)
            if popUpView.frame.contains(touchPoint) {
                nameTextField.resignFirstResponder()
            } else {
                dismiss()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let textString = text.replacingCharacters(in: range, with: string)
            nameToAdd = textString
            addButton.alpha = textString.isEmpty ? 0.5 : 1
            addButton.isEnabled = !textString.isEmpty
        }
        return true
    }
}
