//
//  MainViewCell.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 27.06.2023.
//

import UIKit
import SnapKit

protocol ImageTapDelegate {
    func imageTap(uuid: String?)
}

final class MainViewCell: UICollectionViewCell,
                          ReusableCell {
    
    var delegate: ImageTapDelegate?
    private var imageUUID: String?
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var cellImage: LoadableImageView = {
        let imageView = LoadableImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(imageTap)
        )
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var cellStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.distribution = .fill
        stack.backgroundColor = .clear
        [
            headerLabel,
            textLabel,
            cellImage
        ].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    private var type: BlockType = .text
    
    func setup(
        block: Block
    ) {
        guard let blockType = BlockType(rawValue: block.type) else { return }
        self.type = blockType
        switch type {
        case .text:
            headerLabel.text = ""
            textLabel.text = block.data.text
            cellImage.isHidden = true
        case .media, .list:
            block.data.items?.forEach { union in
                switch union {
                case .image(let imageData):
                    cellImage.isHidden = false
                    headerLabel.text = imageData.title
                    imageUUID = imageData.image.data.uuid
                    cellImage.downloadedFrom(
                        urlString: APIEndpoint
                            .base.loadImage(
                                with: imageUUID ?? ""
                            )
                    )
                case .list(let string):
                    headerLabel.text = ""
                    cellImage.isHidden = true
                    var list: [String] = []
                    list.append(string)
                    textLabel.text = list.description
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
extension MainViewCell {
    private func setupElements() {
        contentView.addSubview(cellStack)
        cellStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
        }
        textLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
        }
        cellImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(contentView.frame.width)
            make.height.equalTo(240)
        }
        cellImage.isHidden = true
    }
    
    @objc private func imageTap() {
        delegate?.imageTap(uuid: imageUUID)
    }
}
