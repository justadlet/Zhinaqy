//
//  SceneDelegate.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

@available(iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: winScene)
        window?.rootViewController = DependencyContainer.shared.makeRootView()
        window?.makeKeyAndVisible()
    }

    
    func sceneDidEnterBackground(_ scene: UIScene) {
        DependencyContainer.shared.coreDataManager.saveContext()
    }


}

