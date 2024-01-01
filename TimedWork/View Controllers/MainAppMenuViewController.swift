//
//  MainAppMenuViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 09.12.23.
//

import Cocoa


class MainAppMenuViewController: NSViewController {
    
    @IBOutlet var collectionView: NSCollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(onEntityChanged(notification:)), name: .activityDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEntityChanged(notification:)), name: .activityCreated, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction private func onEntityChanged(notification: Notification) {
        collectionView.reloadData()
    }
}

extension MainAppMenuViewController : NSCollectionViewDelegate {
    private func configureCollectionView() {
        collectionView.register(SidebarCollectionViewItem.self, forItemWithIdentifier: SidebarCollectionViewItem.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = listLayout()
        collectionView.setFrameSize(NSSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 1))
        
        collectionView.reloadData()
    }
    
    private func listLayout() -> NSCollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 5)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(15))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: NSCollectionView.elementKindSectionHeader,
                        alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        let layout = NSCollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension MainAppMenuViewController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return Sidebar().computeSections().count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return Sidebar().computeSections()[SidebarSection(rawValue: section)!]!.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let view = collectionView.makeItem(withIdentifier: SidebarCollectionViewItem.identifier, for: indexPath) as! SidebarCollectionViewItem
        let data = Sidebar().computeSections()[SidebarSection(rawValue: indexPath.section)!]![indexPath.item]
        view.updateViews(data: data)
        return view
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        switch kind {
        case NSCollectionView.elementKindSectionHeader:
        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: SidebarHeaderView.identifier, for: indexPath) as! SidebarHeaderView
            view.titleText.stringValue = "\(String(describing: SidebarSection(rawValue: indexPath.section)!.description))"
            let image = NSImage(systemSymbolName: "chevron.right", accessibilityDescription: nil)
            let imageConfig = NSImage.SymbolConfiguration(textStyle: .body, scale: .small)
            view.chevronImageView.image = image?.withSymbolConfiguration(imageConfig)
        return view
        default:
            return NSView()
        }
    }
    
//    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
//
//        let string = strings[indexPath.item]
//        let size = NSTextField(labelWithString: string).sizeThatFits(NSSize(width: 400, height: 800))
//
//        return NSSize(width: 400, height: size.height > 80 ? size.height : 80)
//    }
}


