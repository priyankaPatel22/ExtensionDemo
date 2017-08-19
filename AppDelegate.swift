//  
//  AppDelegate.swift
//  GriefPath
//
//  Created by Gautam Metaliya on 12/21/16.
//  Copyright (c) 2016 infinium. All rights reserved.
//

import UIKit
import MMDrawerController
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate,GIDSignInDelegate{
    
    var window : UIWindow?
    
    // info
    
    var id : String!
    var fName : String!
    var lName : String!
    var homePhone : String!
    var mobile : String!
    var email : String!
    var address1 : String!
    var address2 : String!
    var city : String!
    var state : String!
    var zip : String!
    var DOB : String!
    
    var diedId : String!
    var diedFName : String!
    var diedLName : String!
    var diedDOB : String!
    var diedDOD : String!
    var diedCause : String!
    var diedNotes : String!
    var diedRelation : String!
    var memorialDonationArr:NSMutableArray=NSMutableArray()
    
    var deceasedDOD_r_id : String!
    var deceasedDOD : String!

    var deceasedDOB_r_id : String!
    var swDeceasedDOB : String = "1"
    var deceasedDOB : String!
    
    var bereavedDOB_r_id : String!
    var swBereavedDOB : String="1"
    var bereavedDOB : String!
    
    var fatherDay_r_id : String!
    var swFatherDay : String="0"
    var fatherDay : String!
    
    var motherDay_r_id : String!
    var swMotherDay : String="0"
    var motherDay : String!
    
    var christmas_r_id : String!
    var swChristmas : String="0"
    var christmas : String!
    
    var easter_r_id : String!
    var swEaster : String="0"
    var easter : String!
    
    var thanksgiving_r_id : String!
    var swThanksgiving : String="0"
    var thanksgiving : String!
    
    var bereavedWedAnni_r_id : String!
    var swBereavedWedAnni : String="0"
    var bereavedWedAnni : String!
    
    var otherAnni_r_id : String!
    var swOtherAnni : String="0"
    var otherAnni : String!
    var otherAnniReminderTitle : String!
    
    var otherHoliday_r_id : String!
    var swOtherHoliday : String="0"
    var otherHoliday : String!
    var otherHolidayReminderTitle : String!
    
    var otherImportantDate_r_id : String!
    var swOtherImportantDate : String="0"
    var otherImportantDate : String!
    var otherImportantDateReminderTitle : String!
    
    var otherMilestone_r_id : String!
    var swOtherMilestone : String="0"
    var otherMilestone : String!
    var otherMilestoneReminderTitle : String!
    
    var passover_r_id : String!
    var swPassover : String="0"
    var passover : String!
    
    var roshHashanah_r_id : String!
    var swRoshHashanah : String="0"
    var roshHashanah : String!
    
    var yomKippur_r_id : String!
    var swYomKippur : String="0"
    var yomKippur : String!
    
    var hanukkah_r_id : String!
    var swHanukkah : String="0"
    var hanukkah : String!
    
    var yarzheit_r_id : String!
    var swYarzheit : String="0"
    var yarzheit : String!
    
    var eidAlFitr_r_id : String!
    var swEidAlFitr : String="0"
    var eidAlFitr : String!
    
    var eidAlAdha_r_id : String!
    var swEidAlAdha : String="0"
    var eidAlAdha : String!
    
    var remindBefore2Weeks : String="0"
    var remindBefore1Week : String="0"
    var remindBefore1Day : String="0"
    var remindDayOf : String="0"
    
    var swRemindOngoingFirst : String="0"
    var remindOngoingStringFirst : String="Weekly"
    
    var remindOngoingStringSecond : String="One year"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let settings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes:[.Sound, .Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        FIRApp.configure()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(tokenRefreshNotification(_:)),
                                                         name: kFIRInstanceIDTokenRefreshNotification,
                                                         object: nil)
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad)
        {
            let storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
            let rootController = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = rootController
            self.window?.makeKeyAndVisible()
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = rootController
            self.window?.makeKeyAndVisible()
        }
        if NSUserDefaults.standardUserDefaults().boolForKey("isStarted")
        {
            self.setupSideBar()
        }
        
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary
        {
            print("\(remoteNotification)")
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad)
            {
                if (NSUserDefaults.standardUserDefaults().objectForKey("user_id") != nil)
                {
                    let storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
                    let vc=(storyboard.instantiateViewControllerWithIdentifier("ReminderActionControllerForNotification")) as! ReminderActionControllerForNotification
                    let reminderDict : NSMutableDictionary = NSMutableDictionary()
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.b_fullname") as! String, forKey: "b_fullname")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.b_id") as! String, forKey: "b_id")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.bere_person_relation") as! String, forKey: "bere_person_relation")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.d_fullname") as! String, forKey: "d_fullname")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.d_id") as! String, forKey: "d_id")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_date") as! String, forKey: "reminder_date")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_id") as! String, forKey: "reminder_id")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_name") as! String, forKey: "reminder_name")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_status") as! String, forKey: "reminder_status")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_status_action") as! String, forKey: "reminder_status_action")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_title") as! String, forKey: "reminder_title")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.message") as! String, forKey: "message")
                    vc.reminderDict=reminderDict
                    self.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
                }
            }
            else
            {
                if (NSUserDefaults.standardUserDefaults().objectForKey("user_id") != nil)
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc=(storyboard.instantiateViewControllerWithIdentifier("ReminderActionControllerForNotification")) as! ReminderActionControllerForNotification
                    let reminderDict : NSMutableDictionary = NSMutableDictionary()
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.b_fullname") as! String, forKey: "b_fullname")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.b_id") as! String, forKey: "b_id")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.bere_person_relation") as! String, forKey: "bere_person_relation")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.d_fullname") as! String, forKey: "d_fullname")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.d_id") as! String, forKey: "d_id")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_date") as! String, forKey: "reminder_date")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_id") as! String, forKey: "reminder_id")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_name") as! String, forKey: "reminder_name")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_status") as! String, forKey: "reminder_status")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_status_action") as! String, forKey: "reminder_status_action")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.reminder_title") as! String, forKey: "reminder_title")
                    reminderDict.setValue(remoteNotification.objectForKey("gcm.notification.message") as! String, forKey: "message")
                    vc.reminderDict=reminderDict
                    self.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
                }
            }
        }
        return true
    }
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        let isFacebookURL = url.scheme != nil && url.scheme!.hasPrefix("fb\(FBSDKSettings.appID())") && url.host == "authorize"
        
        if isFacebookURL
        {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else
        {
            return GIDSignIn.sharedInstance().handleURL(url,
                                                        sourceApplication: sourceApplication,
                                                        annotation: annotation)
        }
    }
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            print("fullName=\(fullName)")
            print("givenName=\(givenName)")
            print("familyName=\(familyName)")
            print("email=\(email)")
            
            let userInfo : NSMutableDictionary = NSMutableDictionary()
            userInfo.setObject(fullName, forKey: "fullName")
            userInfo.setObject(email, forKey: "email")
            NSNotificationCenter.defaultCenter().postNotificationName("fetchUserInfoForGoogle", object: nil, userInfo: userInfo as [NSObject : AnyObject])
        }
        else
        {
            print("\(error.localizedDescription)")
        }
    }
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    func application(application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("APNs token retrieved: \(deviceToken)")
    }
    //Called if unable to register for APNS.
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        let userNotificationInfo = userInfo as NSDictionary
        print("\(userNotificationInfo)")
        
        if(application.applicationState == UIApplicationState.Inactive)
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad)
            {
                if (NSUserDefaults.standardUserDefaults().objectForKey("user_id") != nil)
                {
                    let storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
                    let vc=(storyboard.instantiateViewControllerWithIdentifier("ReminderActionControllerForNotification")) as! ReminderActionControllerForNotification
                    let reminderDict : NSMutableDictionary = NSMutableDictionary()
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.b_fullname") as! String, forKey: "b_fullname")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.b_id") as! String, forKey: "b_id")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.bere_person_relation") as! String, forKey: "bere_person_relation")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.d_fullname") as! String, forKey: "d_fullname")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.d_id") as! String, forKey: "d_id")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_date") as! String, forKey: "reminder_date")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_id") as! String, forKey: "reminder_id")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_name") as! String, forKey: "reminder_name")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_status") as! String, forKey: "reminder_status")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_status_action") as! String, forKey: "reminder_status_action")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_title") as! String, forKey: "reminder_title")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.message") as! String, forKey: "message")
                    vc.reminderDict=reminderDict
                    self.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
                }
            }
            else
            {
                if (NSUserDefaults.standardUserDefaults().objectForKey("user_id") != nil)
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc=(storyboard.instantiateViewControllerWithIdentifier("ReminderActionControllerForNotification")) as! ReminderActionControllerForNotification
                    let reminderDict : NSMutableDictionary = NSMutableDictionary()
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.b_fullname") as! String, forKey: "b_fullname")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.b_id") as! String, forKey: "b_id")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.bere_person_relation") as! String, forKey: "bere_person_relation")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.d_fullname") as! String, forKey: "d_fullname")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.d_id") as! String, forKey: "d_id")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_date") as! String, forKey: "reminder_date")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_id") as! String, forKey: "reminder_id")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_name") as! String, forKey: "reminder_name")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_status") as! String, forKey: "reminder_status")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_status_action") as! String, forKey: "reminder_status_action")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.reminder_title") as! String, forKey: "reminder_title")
                    reminderDict.setValue(userNotificationInfo.objectForKey("gcm.notification.message") as! String, forKey: "message")
                    vc.reminderDict=reminderDict
                    self.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
                }
            }
        }
        else
        {
            let notificationBar = GLNotificationBar(title: "", message: userNotificationInfo.objectForKey("aps")?.objectForKey("alert") as! String, preferredStyle: .SimpleBanner, handler: { (result) in
                
            })
            notificationBar.notificationSound("notification", ofType: ".mp3", vibrate: false)
        }
    }
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token()
        {
            print("InstanceID token: \(refreshedToken)")
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(refreshedToken, forKey: "device_token")
            defaults.synchronize()
        }
        else
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("", forKey: "device_token")
            defaults.synchronize()
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        FBSDKAppEvents.activateApp()
        connectToFcm()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func setupSideBar() {
        let centerContainer:MMDrawerController
        
        let storyboard:UIStoryboard
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad)
        {
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        else
        {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
    
        if (NSUserDefaults.standardUserDefaults().objectForKey("user_id") != nil)
        {
            let centerViewController:UIViewController!
            centerViewController = storyboard.instantiateViewControllerWithIdentifier("HomeScreenViewController") as! HomeScreenViewController
            let leftViewController = storyboard.instantiateViewControllerWithIdentifier("SideBarViewController") as! SideBarViewController
            let leftSideNav = UINavigationController(rootViewController: leftViewController)
            let centerNav = UINavigationController(rootViewController: centerViewController)
            centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav,rightDrawerViewController:nil)
            centerContainer.openDrawerGestureModeMask = MMOpenDrawerGestureMode.All
            centerContainer.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad)
            {
                centerContainer.maximumLeftDrawerWidth=400.0
            }
            else
            {
                centerContainer.maximumLeftDrawerWidth=270.0
            }
            
            window!.rootViewController = centerContainer
            window!.makeKeyAndVisible()
        }
        else
        {
            let ViewController:UIViewController!
            ViewController = storyboard.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
            let NavViewController = UINavigationController(rootViewController: ViewController)
            window!.rootViewController = NavViewController
            window!.makeKeyAndVisible()
        }
    }
}

