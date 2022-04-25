//
//  LayoutAnchorKit.swift
//  LayoutAnchorKit
//
//  Created by Mikhail Vospennikov on 30.11.2021.
//

import UIKit

public protocol LayoutAnchor {
    func constraint(equalTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
}
public protocol DimensionalLayoutAnchor: LayoutAnchor {
    func constraint(equalToConstant c: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: LayoutAnchor { }
extension NSLayoutDimension: DimensionalLayoutAnchor { }

public struct LayoutProperty<Anchor: LayoutAnchor> {
    private let anchor: Anchor
    
    public init(anchor: Anchor) {
        self.anchor = anchor
    }
}

public class LayoutProxy {
    public lazy var leading = property(with: view.leadingAnchor)
    public lazy var safeLeading = property(with: view.safeAreaLayoutGuide.leadingAnchor)
    public lazy var trailing = property(with: view.trailingAnchor)
    public lazy var safeTrailing = property(with: view.safeAreaLayoutGuide.trailingAnchor)
    public lazy var top = property(with: view.topAnchor)
    public lazy var safeTop = property(with: view.safeAreaLayoutGuide.topAnchor)
    public lazy var bottom = property(with: view.bottomAnchor)
    public lazy var safeBottom = property(with: view.safeAreaLayoutGuide.bottomAnchor)
    public lazy var width = property(with: view.widthAnchor)
    public lazy var height = property(with: view.heightAnchor)
    public lazy var centerX = property(with: view.centerXAnchor)
    public lazy var centerY = property(with: view.centerYAnchor)
    
    private let view: UIView
    
    fileprivate init(view: UIView) {
        self.view = view
    }
    
    private func property<A: LayoutAnchor>(with anchor: A) -> LayoutProperty<A> {
        LayoutProperty(anchor: anchor)
    }
}

extension LayoutProperty {
    @discardableResult
    public func equal(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = anchor.constraint(equalTo: otherAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func greaterThanOrEqual(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func lessThanOrEqual(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
}

extension LayoutProperty where Anchor: DimensionalLayoutAnchor {
    @discardableResult
    public func equal(constant: CGFloat) -> NSLayoutConstraint {
        let constraint = anchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
}

extension UIView {
    public func layout(using closure: (LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(LayoutProxy(view: self))
    }
}
public func +<A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, rhs)
}

public func -<A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, -rhs)
}

public func ==<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) {
    lhs.equal(to: rhs.0, offsetBy: rhs.1)
}

public func ==<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.equal(to: rhs)
}

public func ==<A: DimensionalLayoutAnchor>(lhs: LayoutProperty<A>, rhs: CGFloat) {
    lhs.equal(constant: rhs)
}

public func >=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) {
    lhs.greaterThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

public func >=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.greaterThanOrEqual(to: rhs)
}

public func <=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) {
    lhs.lessThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

public func <=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.lessThanOrEqual(to: rhs)
}
