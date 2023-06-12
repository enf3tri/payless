//
//  DetailVCViewController.swift
//  payless
//
//  Created by Mert Ünver on 17.12.2022.
//

import UIKit
import CoreData

class DetailVCViewController: UIViewController {


    @IBOutlet weak var Amount: UITextField! {
        didSet {
            let redPlaceholderText = NSAttributedString(string: "Amount",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            Amount.attributedPlaceholder = redPlaceholderText
        }
    }
    @IBOutlet weak var Companys: UITextField! {
        didSet {
            let rediPlaceholderText = NSAttributedString(string: "Company",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            Companys.attributedPlaceholder = rediPlaceholderText
        }
    }
    @IBOutlet weak var Dates: UITextField! {
        didSet {
            let rediiPlaceholderText = NSAttributedString(string: "Date",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            Dates.attributedPlaceholder = rediiPlaceholderText
        }
    }
    var selectedNote: Note? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedNote != nil)
                {
                    Amount.text = selectedNote?.total
                    Companys.text = selectedNote?.company
                }
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func saveAction(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedNote == nil)
        {
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.total = Amount.text
            newNote.company = Companys.text
           
            do
            {
                try context.save()
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
            }
            catch
            {
                print("context save error")
            }
        }
        else //edit
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    if(note == selectedNote)
                    {
                        note.total = Amount.text
                        note.company = Companys.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
    }
    private let fileName = "route.json"
    
    @IBAction func DeleteNote(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let note = result as! Note
                if(note == selectedNote)
                {
                    note.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch
        {
            print("Fetch Failed")
        }
    }
    @objc func readFiles(notification: NSNotification) {
        let fileManager = FileManager.default
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        guard let docDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }

        let inputFileURL = docDirectoryURL.appendingPathComponent(fileName)

        guard fileManager.fileExists(atPath: inputFileURL.path)
        else {
            logToTextView("File Doesn't exist. Try typing a name and hitting 'Save' First.")
            return
        }

        do {
            logToTextView("Attempting to read from \(fileName)")
            logToTextView("Reading from file at path \(inputFileURL.deletingLastPathComponent().path)")
            let inputData = try Data(contentsOf: inputFileURL)
            let decoder = JSONDecoder()
            let decodedString = try decoder.decode(String.self, from: inputData)
            logToTextView("previous name contents = [\(decodedString)]")
            print(decodedString)
            calculate(current: decodedString, new: Amount.text ?? "0")
        } catch {
            logToTextView("Failed to open file contents for display!")
            return
        }
        
    }
    func sumStrings(a: String, b: String) -> String? {
        // Attempt to convert the input strings to integers
        guard let intA = Int(a), let intB = Int(b) else {
            // If one or both of the strings cannot be converted to integers, return nil
            return nil
        }

        // Sum the integers
        let sum = intA + intB

        // Convert the result to a string and return it
        return String(sum)
    }
    
    func calculate(current:String,new:String){
        let result = sumStrings(a: current, b: new)
        print(result)
    }
    private func logToTextView(_ whatToLog: String) {
        print(whatToLog)
    }
    
    func writeToFileAs(place_name: String ){
        let usersName = place_name
        
        guard let docDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }

    
        let outputURL = docDirectoryURL.appendingPathComponent(fileName)

        do {
            
            let jsonEncoder = JSONEncoder()
            let jsonCodedData = try jsonEncoder.encode(usersName)
            try jsonCodedData.write(to: outputURL)
            
        } catch {

            logToTextView("Failed to write to file \(error.localizedDescription)")
            return
        }


        logToTextView("Wrote to \(fileName)")
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
