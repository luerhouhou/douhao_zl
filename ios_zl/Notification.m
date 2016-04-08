User Notifications
    Must register to use
    Require user approval
UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
[[UIApplication sharedApplication] registerUserNotificationSettings:notiSettings];

//--------------------
#program mark - UIApplicationDelegate Callback
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //user has allowes receiving user notifications of the following types
    UIUserNotificationType allowedTypes = [notificationSettings types];
    //register to receive notifications
    
    [application registerForRemoteNotifications];
    
}

// Registering UIUserNotificationSettings more than once results in previous settings being overwritten.
- (void)registerUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings NS_AVAILABLE_IOS(8_0);

// Returns the enabled user notification settings, also taking into account any systemwide settings.
- (UIUserNotificationSettings *)currentUserNotificationSettings NS_AVAILABLE_IOS(8_0);

// categories may be nil or an empty set if custom user notification actions will not be used
+ (instancetype)settingsForTypes:(UIUserNotificationType)types
                      categories:(NSSet *)categories; // instances of UIUserNotificationCategory


//--------------------------
(Using) Notification Actions
    Register Actions
    Push/Schedule Notification
    Handle Action

UIMutableUserNotificationAction : UIUserNotificationAction

UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
// The unique identifier for this action.
    acceptAction.identifier = @"ACCEPT_IDENTIFER";

// The localized title to display for this action.
    acceptAction.title = @"Accept";

// How the application should be activated in response to the action.
@property (nonatomic, assign) UIUserNotificationActivationMode activationMode;
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;

    UIUserNotificationActivationModeForeground, // activates the application in the foreground
    UIUserNotificationActivationModeBackground  // activates the application in the background, unless it's already in the foreground

// Whether this action is secure and should require unlocking before being performed. If the activation mode is UIUserNotificationActivationModeForeground, then the action is considered secure and this property is ignored.
@property (nonatomic, assign, getter=isAuthenticationRequired) BOOL authenticationRequired;
    acceptAction.authenticationRequired = NO;//If YES requires passcode, but does not unlock the device.

// Whether this action should be indicated as destructive when displayed.
@property (nonatomic, assign, getter=isDestructive) BOOL destructive;
    acceptAction.destructive = NO;

@end

Local Notifications

Remote Notifications        APNS

User --> Requires call to registerUserNotificationSettings

Silent --> Info.plist UIBackgroundModes array contains remote-notification

Can use both

RemoteNotification
Must register before using
Enabled by default
Register API change (registerForRemoteNotifications)

// Calling this will result in either application:didRegisterForRemoteNotificationsWithDeviceToken: or application:didFailToRegisterForRemoteNotificationsWithError: to be called on the application delegate. Note: these callbacks will be made only if the application has successfully registered for user notifications with registerUserNotificationSettings:, or if it is enabled for Background App Refresh.
- (void)registerForRemoteNotifications NS_AVAILABLE_IOS(8_0);
- (void)unregisterForRemoteNotifications NS_AVAILABLE_IOS(3_0);


[Location Notifications]

    Uses UILocatlNotification
    Fire when user enters or exits a region
    fire-Once or Fire-Always
    Requires Core Location registration


[Core Location]
    Location authorization
    Visit monitoring
    Indoor positioning

