//
//  EditPlaylistViewController.swift
//  VkPlaylist
//
//  Created by Илья Халяпин on 30.05.16.
//  Copyright © 2016 Ilya Khalyapin. All rights reserved.
//

import UIKit

class EditPlaylistViewController: UIViewController {
    
    var playlistToEdit: Playlist?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var playlistTitleTextField: UITextField!
    @IBOutlet weak var editPlaylistTableViewControllerContainer: UIView!
    
    weak var editPlaylistMusicTableViewController: EditPlaylistMusicTableViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка клавиатуры для поля с названием плейлиста
        let doneToolBar = UIToolbar(frame: CGRectMake(0, 0, view.frame.size.width, 40))
        doneToolBar.barStyle = .Default
        doneToolBar.tintColor = (UIApplication.sharedApplication().delegate as! AppDelegate).tintColor
        doneToolBar.backgroundColor = UIColor.whiteColor()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        
        doneToolBar.setItems([flexSpace, doneButton], animated: true)
        
        playlistTitleTextField.inputAccessoryView = doneToolBar
        playlistTitleTextField.delegate = self
        
        playlistTitleTextField.text = playlistToEdit?.title
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.showEditPlaylistMusicTableViewControllerInContainerSegue {
            let editPlaylistMusicTableViewController = segue.destinationViewController as! EditPlaylistMusicTableViewController
            editPlaylistMusicTableViewController.playlistToEdit = playlistToEdit
            
            self.editPlaylistMusicTableViewController = editPlaylistMusicTableViewController
        }
    }
    
    
    // MARK: Кнопки на навигационной панели
    
    // Вызывается при тапе по кнопке "Отмена"
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Вызывается при тапе по кнопке "Сохранить"
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        view.endEditing(true)
        
        let title = playlistTitleTextField.text! == "" ? "Новый плейлист" : playlistTitleTextField.text!
        let tracks = editPlaylistMusicTableViewController.tracks
        
        if let playlistToEdit = playlistToEdit {
            DataManager.sharedInstance.updatePlaylist(playlistToEdit, withTitle: title, andTracks: tracks)
        } else {
            DataManager.sharedInstance.createPlaylistWithTitle(title, andTracks: tracks)
        }
            
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Обработка пользовательских событий
    
    // Нажата кнопка готово на тулбаре клавиатуры для ввода названия плейлиста
    func donePressed(sender: UIBarButtonItem) {
        playlistTitleTextField.resignFirstResponder()
    }

}


// MARK: UITextFieldDelegate

extension EditPlaylistViewController: UITextFieldDelegate {
    
    // Была нажата кнопка готово
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
}
