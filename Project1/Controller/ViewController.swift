
import UIKit
import Foundation
import CoreData


protocol StudentUpdateDelegate: AnyObject {
    func didSelectStudent(_ student: Student, at indexPath: IndexPath)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var studentTableView: UITableView!

    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        students = DBManager.share.fetchStudent()
        studentTableView.reloadData()
    }
    
    // Get date from the Api
    func fetchDataFromAPI() {
        APIClient.shared.fetchDataFromAPI { [weak self] unicornModels, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching data from API: \(error.localizedDescription)")
                return
            }

            guard let unicornModels = unicornModels else { return }

            self.saveDataToCoreData(unicornModels)

            DispatchQueue.main.async {
                // Update your array of students from CoreData
                self.students = DBManager.share.fetchStudent()
                self.studentTableView.reloadData()
            }
        }
    }
    
    // Update the value to the UITableView cell
    func saveDataToCoreData(_ apiData: [UnicornModel]) {
           let context = DBManager.share.persistentContainer.viewContext

           for crudSubModel in apiData {
               // Check if the data with the same unique identifier (_id) already exists
               let existingStudents = fetchStudent(withID: crudSubModel._id)

               if existingStudents.isEmpty {
                   let newStudent = Student(context: context)
                   newStudent.name = crudSubModel.name
                   newStudent.email = crudSubModel.colour
                   newStudent.gender = crudSubModel._id
                   // Set other properties as needed

                   do {
                       try context.save()
                   } catch {
                       print("Error saving to CoreData: \(error.localizedDescription)")
                   }
               }
           }
       }
    
    
    // Fetch students with a specific ID
       func fetchStudent(withID id: String) -> [Student] {
           let context = DBManager.share.persistentContainer.viewContext
           let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "gender == %@", id)

           do {
               let existingStudents = try context.fetch(fetchRequest)
               return existingStudents
           } catch {
               print("Error fetching existing students: \(error.localizedDescription)")
               return []
           }
       }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource , StudentUpdateDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? AddTableViewCell else {
            // Handle the case when cell is nil, return a placeholder cell or an empty cell
            return UITableViewCell()
        }

        let aStudent = students[indexPath.row]
        cell.txtAddName?.text = aStudent.name
        cell.txtAddEmail?.text = aStudent.email
        cell.txtAddGender?.text = aStudent.gender

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let context = DBManager.share.context
            context.delete(students[indexPath.row])
            DBManager.share.saveContext()
            students.remove(at: indexPath.row)
            studentTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let selectedStudent = students[indexPath.row]

         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if let addStudentVC = storyboard.instantiateViewController(withIdentifier: "AddStudentVC") as? AddStudentVC {
             addStudentVC.delegate = self
             addStudentVC.selectedStudent = selectedStudent
             addStudentVC.indexPath = indexPath
             navigationController?.pushViewController(addStudentVC, animated: true)
         }
     }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // Implement the StudentUpdateDelegate method
       func didSelectStudent(_ student: Student, at indexPath: IndexPath) {
           students[indexPath.row] = student
           studentTableView.reloadData()
       }
    
    
}

