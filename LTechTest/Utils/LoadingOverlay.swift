//
//  LoadingOverlay.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import UIKit
import Lottie
import SnapKit

final class LoadingOverlay {

    // MARK: - Static

    static let shared = LoadingOverlay()

    // MARK: - Private Properties

    private var animationView: LottieAnimationView?
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .lWhite
        
        return view
    }()

    private lazy var lottieView: LottieAnimationView? = {
        let animation = LottieAnimation.named("loading")
        let view = LottieAnimationView(animation: animation)
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        
        return view
    }()

    // MARK: - Public Methods

    func show(over view: UIView) {
        guard overlayView.superview == nil else { return }

        guard let animationView = lottieView else { return }

        overlayView.addSubview(animationView)
        view.addSubview(overlayView)

        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(300)
        }

        animationView.layer.sublayers?.removeAll(where: { $0.name == "Lottie" })
        animationView.play()
    }

    func hide() {
        animationView?.stop()
        overlayView.removeFromSuperview()
        animationView = nil
    }

    // MARK: - Init

    private init() {}
}
