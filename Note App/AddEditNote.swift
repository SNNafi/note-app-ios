//
//  AddEditNote.swift
//  Note App
//
//  Created by Shahriar Nasim Nafi on 9/10/20.
//  Copyright © 2020 Shahriar Nasim Nafi. All rights reserved.
//

import UIKit

class AddEditNote: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contenttextView: UITextView!
    @IBOutlet weak var selectPriority: UIPickerView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let priorities = [Prority(id: 1, name: "Low"),Prority(id: 0, name: "High")]
    var noteForEdit: Note?
    var priority = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectPriority.delegate = self
        selectPriority.dataSource = self
        titleTextField.delegate = self
        contenttextView.delegate = self
        
        if let note = noteForEdit{
            titleTextField.text = note.title
            contenttextView.text = note.content
            selectPriority.selectRow(!note.priority ? 1 : 0, inComponent: 0, animated: true)
            title = "Edit Note"
            doneButton.isEnabled = true
        }else{
            title = "Add Note"
            contenttextView.text = Constant.textView
            contenttextView.textColor = UIColor.lightGray
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: UIBarButtonItem){
        if let note = noteForEdit{
            note.priority = priority == 0 ? false : true
            note.title = titleTextField.text!
            note.content = contenttextView.text!
            do{
                try context.save()
            }catch {
                fatalError("\(error.localizedDescription)")
            }
        }else{
            let note = Note(context: context)
            note.id = Note.generateNoteId()
            note.title = titleTextField.text!
            note.content = contenttextView.text!
            note.priority = priority == 0 ? false : true
            do{
                try context.save()
            }catch {
                fatalError("\(error.localizedDescription)")
            }
        }
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
    
    struct Prority {
        let id: Int
        let name: String
    }
    
    
}

extension AddEditNote: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        priorities.count
    }
    
    
}

extension AddEditNote: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(priorities[row].name)
        priority = priorities[row].id
        
        
    }
}


extension AddEditNote: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = titleTextField.text!
        let stringRange = Range(range,in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    
}

extension AddEditNote: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constant.textView
            textView.textColor = UIColor.lightGray
        }
    }
    
}

