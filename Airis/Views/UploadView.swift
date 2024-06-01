import Foundation
import UIKit

class UploadView: UIView {
    private let lblText = UILabel()
    private let uploadImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 15
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        setupLayerSettings()
        
        let containerView = UIView()
        let tintColor = UIColor(hex: "#3C4048", alpha: 1)
        uploadImageView.image = UIImage(systemName: "square.and.arrow.up")
        uploadImageView.tintColor = tintColor
        containerView.addSubview(uploadImageView)
        uploadImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.centerX.top.equalToSuperview()
        }
        
        lblText.text = "Upload Photo"
        lblText.textColor = tintColor
        lblText.font = FontConstants.t2.value
        containerView.addSubview(lblText)
        lblText.snp.makeConstraints { make in
            make.top.equalTo(uploadImageView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        let btnAction = UIButton()
        containerView.addSubview(btnAction)
        btnAction.addTarget(self, action: #selector(onBtnClicked), for: .touchUpInside)
        btnAction.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func onBtnClicked() {
        // TODO: DO something
    }
}
