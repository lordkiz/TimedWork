//
//  ListLayout.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 10.12.23.
//

import Cocoa

class SidebarListLayout: NSCollectionViewCompositionalLayout {
    
    private var expectedViewContentSize: NSSize = NSZeroSize

    override func prepare() {
        super.prepare()
        expectedViewContentSize = NSSize(width: 110, height: 600)
    }
    
    override var collectionViewContentSize: NSSize {
        return expectedViewContentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        super.layoutAttributesForElements(in: rect)
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: NSCollectionView.DecorationElementKind, at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
}
