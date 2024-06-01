import Foundation
import UIKit

class PromptView: UIView {
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        setupLayerSettings()
        
        let lblTitle = UILabel()
        lblTitle.text = "Enter Prompt"
        lblTitle.textColor = ColorConstants.primaryAccent.value
        lblTitle.font = FontConstants.h2.value
        addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
        }
        
        let promptTextView = UITextView()
        promptTextView.font = FontConstants.t2.value
        addSubview(promptTextView)
        promptTextView.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(16)
            // special padding for UITextView
            make.leading.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
