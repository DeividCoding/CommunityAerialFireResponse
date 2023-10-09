//
//  ScrollViewController.swift
//  communityaerial
//
//  Created by Lisette HG on 08/10/23.
//

import UIKit

class ScrollViewController: UIViewController {

    var scrollContainer: UIScrollView? {return nil}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let scroll = self.scrollContainer else { return }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        scroll.backgroundColor = .clear
        self.addTouchesBegan()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            var contentInset: UIEdgeInsets = self.scrollContainer?.contentInset ?? .zero
            contentInset.bottom = keyboardHeight
            scrollContainer?.contentInset = contentInset
        }
    }
    
    func resetContentInset() {
        self.view.endEditing(true)
        if let scroll = self.scrollContainer {
            UIView.animate(withDuration: 0.3) {
                scroll.contentInset = .zero
            }
        }
    }
    
    func addTouchesBegan() {
        if let subViewScrollView = self.scrollContainer?.subviews.first {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTouchBegan(tapGestureRecognizer:)))
            subViewScrollView.addGestureRecognizer(tapGesture)
            subViewScrollView.isUserInteractionEnabled = true
        }
    }
    
    @objc func didTouchBegan(tapGestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.resetContentInset()
    }
}

extension ScrollViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        self.resetContentInset()
        return true
    }
    
}
