//
//  SceneDelegate.swift
//  ScrollTest
//
//  Created by Zouhair Mahieddine on 20/04/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  let tabBarController: UITabBarController = UITabBarController()


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    
    let tabOne = ViewController()
    let tabOneBarItem = UITabBarItem(title: "Tab 1", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
    tabOne.tabBarItem = tabOneBarItem
    
    let tabTwo = ViewController()
    let tabTwoBarItem2 = UITabBarItem(title: "Tab 2", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
    tabTwo.tabBarItem = tabTwoBarItem2

    tabBarController.viewControllers = [tabOne, tabTwo]
    tabBarController.tabBar.backgroundColor = .green
    tabBarController.tabBar.tintColor = .red
    tabBarController.tabBar.unselectedItemTintColor = .blue
    
    window?.rootViewController = tabBarController
    
    
    window?.makeKeyAndVisible()
  }
}

