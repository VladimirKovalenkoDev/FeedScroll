//
//  ViewController.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 27.06.2023.
//

import UIKit
import SnapKit
import Combine
import UIScrollView_InfiniteScroll

final class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private var cancellable: Cancellable?
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout() ?? UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.infiniteScrollDirection = .vertical
        collectionView.allowsMultipleSelection = false
        collectionView.register(
            MainViewCell.self,
            forCellWithReuseIdentifier: MainViewCell.reuseId
        )
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderView"
        )
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        dataBinding()
    }
}

// MARK: - Private methods
extension MainViewController {
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func dataBinding() {
        cancellable = viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            })
        
        collectionView.addInfiniteScroll { [weak self] collection in
            guard let self = self else { return }
            self.viewModel.addAuthor()
            DispatchQueue.main.async {
                collection.finishInfiniteScroll()
            }
        }
    }
    
    private func createLayout() -> UICollectionViewLayout? {
        let spacing: CGFloat = 12
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: 0)
        section.interGroupSpacing = spacing
        
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - Collection Configuration
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfAuthors
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.items[section].data.blocks.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: MainViewCell.reuseId,
                for: indexPath
            ) as? MainViewCell
        else { return UICollectionViewCell() }
        let content = viewModel.items[indexPath.section]
                               .data.blocks[indexPath.row]
        cell.delegate = self
        cell.setup(block: content)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "HeaderView",
                for: indexPath
            ) as? HeaderView else { return UICollectionReusableView()}
            headerView.headerLabel.text = viewModel.items[indexPath.section].data.author.name
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}

extension MainViewController: ImageTapDelegate {
    func imageTap(uuid: String?) {
        let vc = DetailImageController()
        vc.modalPresentationStyle = .fullScreen
        vc.imageUUID = uuid
        present(vc, animated: true)
    }
}
