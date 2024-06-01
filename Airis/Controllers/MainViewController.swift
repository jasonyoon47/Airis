import Foundation
import UIKit

class MainViewController: BaseViewController<MainViewModel> {
    private let contentView = UIView()
    
    override func viewDidLoad() {
        self.view.backgroundColor = ColorConstants.mainBackground.value
        
        let uploadView = UploadView()
        contentView.addSubview(uploadView)
        uploadView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(240)
            make.top.equalTo(16)
        }
        
        let promptView = PromptView()
        contentView.addSubview(promptView)
        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(uploadView.snp.bottom).offset(16)
        }
        
        let btnCreate = MDCButton()
        btnCreate.backgroundColor = ColorConstants.primaryAccent.value
        btnCreate.setTitle("CREATE", for: .normal)
        btnCreate.setTitleFont(FontConstants.h2.value)
        btnCreate.setTitleColor(.white, for: .normal)
        btnCreate.setupLayerSettings()
        btnCreate.layer.cornerRadius = 16
        btnCreate.addTarget(self, action: #selector(onCreateClicked), for: .touchUpInside)
        contentView.addSubview(btnCreate)
        btnCreate.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(80)
            make.height.equalTo(32)
            make.top.equalTo(promptView.snp.bottom).offset(16)
        }
        
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func onCreateClicked() {
        // TODO: Handle create call
        // viewModel.requestCreate..
    }
}
