//
//  MemeTFDelegate.swift
//  ImagePickerTest
//
//  Created by Solomon Dove on 1/12/22.
//

import Foundation
import UIKit

class MemeTFDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}
