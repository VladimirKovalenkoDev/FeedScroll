//
//  DetailImageController.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 29.06.2023.
//

import UIKit
import SnapKit

final class DetailImageController: UIViewController {
    
    var imageUUID: String?
    
    private lazy var detailImage: LoadableImageView = {
        let imageView = LoadableImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(
            pointSize: 40)
        let image = UIImage(
            systemName: "xmark",
            withConfiguration: config
        )
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(closeButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    private func setupElements() {
        view.backgroundColor = .black
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(50)
            make.height.width.equalTo(40)
        }
        guard let imageUUID = imageUUID else { return }
        detailImage.downloadedFrom(
            urlString: APIEndpoint.base.loadImage(
                with: imageUUID
            )
        )
        view.addSubview(detailImage)
        detailImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.frame.height/1.5)
        }
        
    }
    
    @objc private func closeButtonDidTap() {
        dismiss(animated: true)
    }
}
