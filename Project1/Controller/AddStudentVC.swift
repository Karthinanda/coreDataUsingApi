

import UIKit

class AddStudentVC: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    
    
    var selectedStudent: Student?
    var indexPath: IndexPath?
    weak var delegate: StudentUpdateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let student = selectedStudent {
             // Populate the text fields with the selected student's information
              txtName.text = student.name
              txtEmail.text = student.email
              txtGender.text = student.gender
          }
    }
    
    
    @IBAction func onClickAdd(_ sender: Any) {
        guard let name = txtName.text, !name.isEmpty,
              let email = txtEmail.text, !email.isEmpty,
              let gender = txtGender.text, !gender.isEmpty else {
               // Display an alert or take appropriate action for empty text fields
               showAlert(message: "Please fill in all the fields.")
               return
           }
        
        if let name = txtName.text, let email = txtEmail.text, let gender = txtGender.text {
            if let existingStudent = selectedStudent {
                // Update the existing student with the edited values
                existingStudent.name = name
                existingStudent.email = email
                existingStudent.gender = gender

                // Notify the delegate (ViewController) about the changes
                if let indexPath = indexPath {
                    delegate?.didSelectStudent(existingStudent, at: indexPath)
                }

                // Save the context
                DBManager.share.saveContext()
            } else {
                // Creating a new student
                let newStudent = Student(context: DBManager.share.context)
                newStudent.name = name
                newStudent.email = email
                newStudent.gender = gender

                // Save the context
                DBManager.share.saveContext()
            }

            // Dismiss or pop the view controller as needed
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

