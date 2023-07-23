//
//  TextFieldWrapper.swift
//  xcuitest-sample-proj
//
//  Created by Nikola Shabanov on 23.07.23.
//

import SwiftUI

struct TextFieldWrapper: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextField {
            let textField = UITextField()
            textField.delegate = context.coordinator
            
            // Apply the black border to the UITextField
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 1.0
            
            return textField
        }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}
