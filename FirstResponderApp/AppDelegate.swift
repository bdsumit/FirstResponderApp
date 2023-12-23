//
//  AppDelegate.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/9/22.
//

import UIKit
import CoreData
//import NMAKit
import heresdk
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let sharedInstance = UIApplication.shared.delegate as! AppDelegate
    var isOpenApp = false
    var window: UIWindow?
    
    let firebaseService:IVFFirebaseService = VFFirebaseService()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.isOpenApp = true
        window = UIWindow(frame: UIScreen.main.bounds)
       
       
        if UserTempData.returnValue(.appCurrentLanguage) as? String == "English"{
            SetUpAppLanguage.shareInstance.setCurrentAppLanguage(languageType: .english)
        }else{
            SetUpAppLanguage.shareInstance.setCurrentAppLanguage(languageType: .swidish)
        }
        
        initializeHERESDK()
        self.firebaseService.configureFirebase()
        
        return true
    }
    
    private func initializeHERESDK() {
        // Set your credentials for the HERE SDK.
        let accessKeyID = "NmPUpzRwWWCx6Qo0c_et3Q"
        let accessKeySecret = "PrXZypMwr9c2xu0T8330cRdts-ttlKK-FS5YcdoqIAQfCSkXOcz41zKmhb-Hd2L6AFECGQkg81Cq4RYNpmOH2w"
        let options = SDKOptions(accessKeyId: accessKeyID, accessKeySecret: accessKeySecret)
        do {
            try SDKNativeEngine.makeSharedInstance(options: options)
        } catch let engineInstantiationError {
            fatalError("Failed to initialize the HERE SDK. Cause: \(engineInstantiationError)")
        }
    }

    private func disposeHERESDK() {
        // Free HERE SDK resources before the application shuts down.
        // Usually, this should be called only on application termination.
        // Afterwards, the HERE SDK is no longer usable unless it is initialized again.
        SDKNativeEngine.sharedInstance = nil
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Prevent GPU calls when the app runs in background.
        MapView.pause()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        MapView.resume()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Deinitializes map renderer and releases all of its resources.
        // All existing MapView instances will become invalid after this call.
        // Also, the VisualNavigator will become non-functional as it is
        // relying on the map view. If your app is not planned to be terminated
        // after calling deinitialize(), make sure to also call
        // visualNavigator.stopRendering() beforehand.
        MapView.deinitialize()
        disposeHERESDK()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FirstResponderApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
extension UIApplication {
  class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}
