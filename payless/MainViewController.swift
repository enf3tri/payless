//
//  MainViewController.swift
//  payless
//
//  Created by Mert Ünver on 16.12.2022.
//

import UIKit
import CoreData
import VisionKit


var newValue = 20.00
var inter = 3
class MainViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var balance_Count: UILabel!
    @IBOutlet weak var image_circle: UIImageView!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var targetCount: UILabel!
    

    @IBOutlet weak var expenseTableView: UITableView!
    

    let target = 180.00
    
    var company = ["Starbucks","Amazon","BurgerKing","Amazon","Shell"]
    var date = ["16/12/2022","16/12/2022","16/12/2022","16/12/2022","16/12/2022"]
    var price = ["5.20","55.00","7.25","155.0","18.19"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cornerView.layer.cornerRadius = 30
        self.image_circle.image = image_circle.image?.withRenderingMode(.alwaysTemplate)
        if(newValue >= target){
            self.image_circle.tintColor = UIColor(rgb: 0xFF7474)
        }else{
            self.image_circle.tintColor = UIColor(rgb: 0xC9FFB5)
        }
        totalNUM(add: 0.00)
        self.targetCount.text = "\(String(format: "%.2f", target))"
        expenseTableView.dataSource = self
        /*
        cellView.layer.borderWidth = 0.25
        cellView.layer.borderColor = UIColor.black.cgColor
        cellView.layer.cornerRadius = 25
        
        cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cellView.layer.masksToBounds = false
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowRadius = 1
        */
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    @IBAction func seeMore(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            self.totalNUM(add: 155.00)
            inter += 1
            self.expenseTableView.reloadData()
        }

    }
    @IBAction func touchUpInsideCameraButton( Sender:Any){
        configureDocumentView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            self.totalNUM(add: 18.19)
            inter += 1
            self.expenseTableView.reloadData()
        }

    }
    func totalNUM(add:Float){
        newValue = Double(add) + Double(newValue)
        self.balance_Count.text = "\(String(format: "%.2f", newValue))"
        if(newValue >= target){
            self.image_circle.tintColor = UIColor(rgb: 0xFF7474)
        }else{
            self.image_circle.tintColor = UIColor(rgb: 0xC9FFB5)
        }
        
    }
    private func configureDocumentView() {
   //     guard VNDocumentCameraViewController.isSupported else { return } // silinebilir yaratılan metodun controllera uyumununu kontrol eder

        let controller = VNDocumentCameraViewController()
        controller.delegate = self
        self.present(controller, animated: true)
    }

}
extension MainViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController( controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {

    for index in 0 ..< scan.pageCount {
        let image = scan.imageOfPage(at: index)

        print(image)
      // save image
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
}
        controller.dismiss(animated: true, completion: nil)
    }
}
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return inter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expenseTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let company = company[indexPath.row]
        let date = date[indexPath.row]
        let total = price[indexPath.row]
        
        cell.companyName.text = company
        cell.companyLogo.image = UIImage(named:company)
        cell.Date.text = date
        cell.total.text = total
        
        return cell
    }
    

}

var noteList = [Note]()

class NoteTableView: UITableViewController
{
    var firstLoad = true
    
    func nonDeletedNotes() -> [Note]
    {
        var noDeleteNoteList = [Note]()
        for note in noteList
        {
            if(note.deletedDate == nil)
            {
                noDeleteNoteList.append(note)
            }
        }
        return noDeleteNoteList
    }
    
    override func viewDidLoad()
    {
        if(firstLoad)
        {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    noteList.append(note)
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "celli", for: indexPath) as! RTableViewCell
        
        let thisNote: Note!
        thisNote = nonDeletedNotes()[indexPath.row]
        
        noteCell.total.text = thisNote.total
        noteCell.companyName.text = thisNote.company
        
        return noteCell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nonDeletedNotes().count
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "editNote")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let noteDetail = segue.destination as? DetailVCViewController
            
            let selectedNote : Note!
            selectedNote = nonDeletedNotes()[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private let fileName = "route.json"
    
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
            let filterNameArr = decodedString.components(separatedBy: "-")
            for i in filterNameArr {
                print(i)
            }
        } catch {
            logToTextView("Failed to open file contents for display!")
            return
        }
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


    
    

