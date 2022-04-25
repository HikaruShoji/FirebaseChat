//
//  Helper.swift
//  FirebaseChat
//
//  Created by 庄司陽 on 2022/04/13.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.color = .white
        return aiv
    }
    typealias UIViewType = UIActivityIndicatorView
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}

extension Color {
    
    enum AppColor: String {
        case background = "cab8d9"
        case primary = "8b2bd9"
        case lightGreen = "80CF7A"
        case lightBlue = "1FBED6"
    }
    
    static let background = Color(.init(white: 0.95, alpha: 1))
    
    static func myColor(colorCode :Color.AppColor) -> Color {
        return Color(UIColor(hex: colorCode.rawValue))
    }
}

extension Date {
    func timeAgo() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "秒"
            return "たった今"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "分"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "時間"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "日"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "週間"
        } else {
            quotient = secondsAgo / month
            unit = "ヶ月"
        }
        
        return "\(quotient)\(unit)\(quotient == 1 ? "" : "")前"
        
    }
}

// MARK: -ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    private let controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

// MARK: - キーボードを閉じる
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - UITextFieldのextenstion
extension UITextField {
    convenience init(placeholder: String, font: UIFont) {
        self.init(frame: .zero)
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        self.font = font
        self.backgroundColor = UIColor(white: 0, alpha: 0.03)
    }
}

// MARK: - 選択して、項目を入力するpickerの大元
class PickerTextField: UITextField {
    
    var data: [String]
    @Binding var selectionIndex: Int?
    
    init(data: [String], selectionIndex: Binding<Int?>) {
        self.data = data
        self._selectionIndex = selectionIndex
        super.init(frame: .zero)
        
        self.inputView = pickerView
        self.tintColor = .clear
    }
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 0
        return pickerView
    }()
    
    @objc private func donePressed() {
        self.selectionIndex = self.pickerView.selectedRow(inComponent: 0)
        self.endEditing(true)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 選択して、項目を入力するpickerの大元のextention
extension PickerTextField: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectionIndex = row
    }
}
// MARK: - 選択して、項目を入力するタイプ。初期「一部有」としている
struct RemotePickerField: UIViewRepresentable {
    
    @Binding var selectionIndex: Int?
    private var placeholder: String
    private var data: [String]
    private let textField: PickerTextField
    
    init<S>(_ title: S, data: [String], selectionIndex: Binding<Int?>) where S: StringProtocol {
        self.placeholder = String(title)
        self.data = data
        self._selectionIndex = selectionIndex
        
        textField = PickerTextField(data: data, selectionIndex: selectionIndex)
    }
    
    func makeUIView(context: UIViewRepresentableContext<RemotePickerField>) -> UITextField {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<RemotePickerField>) {
        if let index = selectionIndex {
            if index == 0 {
            uiView.text = ""
            } else {
            uiView.text = data[index]
            }
        } else {
            uiView.text = ""
        }
    }
}
struct CheckToggleStyle: ToggleStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.green)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
