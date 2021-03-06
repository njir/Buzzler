//
//  SelectMajorViewController.swift
//  Buzzler
//
//  Created by 진형탁 on 15/05/2018.
//  Copyright © 2018 Maru. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import RxKeyboard
import SVProgressHUD

class SelectMajorViewController: UIViewController, ShowsAlert {
    
    @IBOutlet weak var btn_wrong: UIButton!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var txt_selectMajor: UITextField!
    
    // major list
    var majors: [MajorInfo]?
    var inputUserInfo = UserInfo()
    var viewModel: SelectMajorViewModel?
    
    fileprivate let disposeBag = DisposeBag()
    let router = SignUpRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToRx()
        setUI()
        setPicker()
    }
    
    func bindToRx() {
        self.viewModel = SelectMajorViewModel(provider: BuzzlerProvider, userInfo: inputUserInfo)
        
        guard let selectMajorViewModel = self.viewModel else { return }
        
        btn_next.rx.tap
            .bind(to: selectMajorViewModel.inputs.nextTaps)
            .disposed(by: disposeBag)
        
        txt_selectMajor.rx.text.orEmpty
            .bind(to: selectMajorViewModel.inputs.major)
            .disposed(by: disposeBag)
        
        selectMajorViewModel.outputs.enableNextButton.drive(onNext: { enable in
            self.btn_next.isEnabled = enable
            self.btn_next.layer.borderColor = enable ? Config.UI.buttonActiveColor.cgColor : Config.UI.buttonInActiveColor.cgColor
        }).disposed(by: disposeBag)
        
        
        selectMajorViewModel.outputs.validatedMajor
            .drive()
            .disposed(by: disposeBag)
        
        selectMajorViewModel.outputs.enableNextButton
            .drive()
            .disposed(by: disposeBag)
        
        selectMajorViewModel.outputs.signedUp
            .drive(onNext: { signedUp in
                if signedUp == true {
                    print(signedUp)
                    // push view controller
                    self.router.perform(.done, from: self)
                } else {
                    self.showAlert(message: "Failed to sign up!")
                }
            }).disposed(by: disposeBag)
        
        selectMajorViewModel.isLoading
            .drive(onNext: { isLoading in
                switch isLoading {
                case true:
                    SVProgressHUD.show()
                    break
                case false:
                    SVProgressHUD.dismiss()
                    break
                }
            }).disposed(by: disposeBag)
    }
    
}

extension SelectMajorViewController {
    
    func setUI() {
        // remove "Back" text
        self.navigationController?.navigationBar.topItem?.title = " "
        
        // button
        btn_next.isEnabled = false
        btn_next.setTitleColor(Config.UI.buttonActiveColor, for: UIControlState.normal)
        btn_next.setTitleColor(Config.UI.buttonInActiveColor, for: UIControlState.disabled)
        btn_next.layer.borderWidth = 2.5
        btn_next.layer.borderColor = Config.UI.buttonInActiveColor.cgColor
        
        // textField
        setBorderAndCornerRadius(layer: txt_selectMajor.layer, width: 1, radius: 20, color: Config.UI.textFieldColor)
        setLeftPadding(textField: txt_selectMajor)
    }

}

extension SelectMajorViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func setPicker() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        txt_selectMajor.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let majors = self.majors else { return 0 }
        return majors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let majors = self.majors else { return "" }
        return majors[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let majors = self.majors else { return }
        txt_selectMajor.text = majors[row].name

        var environment = Environment()
        environment.major = majors[row].id
    }
}


