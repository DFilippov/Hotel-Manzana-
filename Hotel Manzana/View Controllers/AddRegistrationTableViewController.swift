 //
//  AddRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Ayu Filippova on 10/08/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    @IBOutlet var numberOFAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    @IBOutlet var wifiSwitch: UISwitch!
    @IBOutlet var roomTypeLabel: UILabel!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    // MARK: - Propeties
    let checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInDatePickerShown: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    var isCheckOutDatePickerShown: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    var roomType: RoomType?
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarButton.isEnabled = false
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SelectRoomType" else { return }
        let destination = segue.destination as! SelectRoomTypeTableViewController
        destination.delegate = self
        destination.roomType = roomType
    }
    
    // MARK: - UI Methods
    func updateDateViews() {
        // плюс один день ко второму datePicker'у добавим (здесь addingTimeInterval указывается в секундах поэтому 60 сек * 60 мин * 24 часа)
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(60 * 60 * 24)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateNumberOfGuests() {
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        numberOFAdultsLabel.text = "\(numberOfAdults)"
        numberOfChildrenLabel.text = "\(numberOfChildren)"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
            if firstNameTextField.text!.isEmpty == false &&
                lastNameTextField.text!.isEmpty == false &&
                validateEmail(text: emailTextField.text ?? "")
            {
                doneBarButton.isEnabled = true
            } else {
                doneBarButton.isEnabled = false
            }
        } else {
            roomTypeLabel.text = "Not Set"
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if firstNameTextField.text!.isEmpty == false &&
            lastNameTextField.text!.isEmpty == false &&
            validateEmail(text: emailTextField.text ?? "") &&
            !roomTypeLabel.text!.contains("Not Set")
        {
            doneBarButton.isEnabled = true
        } else {
            doneBarButton.isEnabled = false
        }
    }
 
    func validateEmail(text: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: text)
    }
    
   
    
    // MARK: - Actions
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let wifi = wifiSwitch.isOn
        
        let registration = Registration(
            firstName: firstName,
            lastName: lastName,
            emailAddress: email,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            numberOfAdults: numberOfAdults,
            numberOfChildren: numberOfChildren,
            roomType: roomType,
            wifi: wifi
        )
        print(#line, #function, registration)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
}

 // MARK: - UITableViewDataSource
 extension AddRegistrationTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerIndexPath:
            return isCheckInDatePickerShown ? UITableView.automaticDimension : 0
        case checkOutDatePickerIndexPath:
            return isCheckOutDatePickerShown ? UITableView.automaticDimension : 0
        default:
            return UITableView.automaticDimension
        }
    }
 }

 // MARK: UITableViewDelegate
 extension AddRegistrationTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case checkInDateLabelIndexPath:
            isCheckInDatePickerShown.toggle()
            isCheckOutDatePickerShown = false
        case checkOutDateLabelIndexPath:
            isCheckInDatePickerShown = false
            isCheckOutDatePickerShown.toggle()
        default:
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
 }
 
 // MARK: - SelectRoomTypeTableViewControllerProtocol
 extension AddRegistrationTableViewController: SelectRoomTypeTableViewControllerProtocol {
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
 }

 extension AddRegistrationTableViewController: UITextFieldDelegate {
 }
