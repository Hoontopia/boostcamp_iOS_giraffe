//
//  SignUpViewController.swift
//  Login
//
//  Created by 임성훈 on 2017. 7. 8..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileTextView: UITextView!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkPasswordField: UITextField!
    
    var id: String?
    var password: String?
    var checkPassword: String?
    
    @IBAction func selectProfileImage(_ sender: UITapGestureRecognizer) {
        // 이미지 피커 컨트롤러 생성
        let imagePicker = UIImagePickerController()
        // 사용자 앨범에서 선택 가능하도록 타입 설정
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    
        // 델리게이트 설정(UIImagePickerControllerDelegate, UINavigationControllerDelegate 두개 필요)
        imagePicker.delegate = self
        // 이미지 피커 모달로 띄움 (권한 설정 필요)
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelSignUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchSignUp(_ sender: UIButton) {
        guard let password: String = password, let checkPass: String = checkPassword
            else { return }
        
        guard !password.isEmpty, !checkPass.isEmpty else {
            print("항목을 모두 입력 해주세요")
            return
        }
        
        // 패스워드와 체크패스워드 같은지 확인
        if password == checkPass {
            dismiss(animated: true, completion: nil)
        } else {
            print("check password")
        }
    }
    
    // 텍스트 필드 입력 완료 시 값 넣어주기
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case idField:
            id = idField.text
        case passwordField:
            password = passwordField.text
        case checkPasswordField:
            checkPassword = checkPasswordField.text
        default:
            break
        }
    }
    
    // 텍스트필드 리턴 시 키보드 없애기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 편집된 이미지를 저장할 이미지로 선택
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            /*
            // 경고 Alert 출력
            let cautionAlert = UIAlertController(title: "오류", message: "선택된 사진이 없습니다.", preferredStyle: .alert)
            cautionAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(cautionAlert, animated: true, completion: nil)
             // whose view is not in the window hierarchy! 에러 발생
            */
            print("선택된 사진이 없습니다.")
            return
        }
        profileImageView.backgroundColor = nil
        profileImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    // 배경 뷰 터치하면 키보드 사라짐
    @IBAction func touchBackgroundView(_ sender: UITapGestureRecognizer) {
        profileTextView.resignFirstResponder()
        idField.resignFirstResponder()
        passwordField.resignFirstResponder()
        checkPasswordField.resignFirstResponder()
    }
}
