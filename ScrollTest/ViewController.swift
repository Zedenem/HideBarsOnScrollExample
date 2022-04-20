//
//  ViewController.swift
//  ScrollTest
//
//  Created by Zouhair Mahieddine on 20/04/2022.
//

import UIKit

class ViewController: UIViewController {
  
  private let topBarHeight: CGFloat = 60
  private lazy var topBarTopAnchorConstraint: NSLayoutConstraint = topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
  private var topBar: UIView = {
    let topBar = UIView()
    topBar.translatesAutoresizingMaskIntoConstraints = false
    topBar.backgroundColor = .yellow
    topBar.alpha = 0.8
    return topBar
  }()
  
  private var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .cyan
    scrollView.contentSize = CGSize(width: 0, height: 3000)
    return scrollView
  }()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    
    scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
    view.addSubview(scrollView)
    view.addSubview(topBar)
    
    NSLayoutConstraint.activate([
      topBarTopAnchorConstraint,
      topBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      topBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      topBar.heightAnchor.constraint(equalToConstant: topBarHeight),
      
      scrollView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  var startOffset: CGPoint = .zero
  var isChromeHidden: Bool = false
  
  @objc
  func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let offset = scrollView.contentOffset
    switch panGestureRecognizer.state {
    case .began:
      startOffset = offset
    case .changed:
      didScroll(yOffsetChange: startOffset.y - offset.y)
    case .failed, .ended, .cancelled:
      didEndPanning()
    default:
      break
    }
  }
}

extension ViewController: UIScrollViewDelegate {
  
  func didScroll(yOffsetChange: CGFloat) {
    let animationTriggerOffsetThreshold = CGFloat(30)
    let animationFractionComplete = abs(yOffsetChange) / animationTriggerOffsetThreshold
    let animationTriggerFractionThreshold = CGFloat(0.6)
    let isDownward = yOffsetChange < 0
    
    if isDownward {
      if isChromeHidden { return }
      
      if animationFractionComplete >= animationTriggerFractionThreshold {
        isChromeHidden = true
        UIView.animate(withDuration: 0.2) { [weak self] in
          guard let self = self else { return }
          
          let maximumOffset = self.topBarHeight
          
          self.topBarTopAnchorConstraint.constant = -maximumOffset
          if let tabBar = self.tabBarController?.tabBar {
            tabBar.frame.origin.y = UIScreen.main.bounds.height + maximumOffset - tabBar.frame.height
            self.additionalSafeAreaInsets.bottom = -maximumOffset
          }
          self.view.layoutIfNeeded()
        }
      }
    } else {
      if !isChromeHidden { return }
      
      if animationFractionComplete >= animationTriggerFractionThreshold {
        isChromeHidden = false
        UIView.animate(withDuration: 0.2) { [weak self] in
          guard let self = self else { return }
          
          self.topBarTopAnchorConstraint.constant = 0
          if let tabBar = self.tabBarController?.tabBar {
            tabBar.frame.origin.y = UIScreen.main.bounds.height - tabBar.frame.height
            self.additionalSafeAreaInsets.bottom = 0
          }
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
  func didEndPanning() {
    
  }
}

