import ProjectDescription

let marketingVersion = SettingValue(stringLiteral: "1.2.0")
let buildNumber = SettingValue(stringLiteral: "1")

let project = Project(
    name: "EatsOkay",
    targets: [
        .target(
            name: "EatsOkay",
            destinations: .iOS,
            product: .app,
            bundleId: "com.curating.EatsOkay",
            deploymentTargets: .iOS("16.6"),
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": true,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ],
                    "UILaunchScreen": [:],
                    "NSLocationWhenInUseUsageDescription": "현재 위치를 기반으로 주변 식당 정보를 제공하기 위해 위치 접근 권한이 필요합니다.",
                    "GoogleAPIKey": "$(GoogleAPIKey)",
                    "KakaoAPIKey": "$(KakaoAPIKey)",
                    "UIUserInterfaceStyle": "Light",
                    "UIAppFonts": [
                        "Pretendard-Bold.ttf",
                        "Pretendard-Medium.ttf",
                        "Pretendard-Regular.ttf"
                    ]
                ]
            ),
            sources: ["EatsOkay/Sources/**"],
            resources: ["EatsOkay/Resources/**"],
            dependencies: [
                .external(name: "SnapKit"),
                
                .external(name: "Moya"),
                .external(name: "RxMoya"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "RxRelay"),
                .external(name: "ReactorKit"),
                .external(name: "RxDataSources"),
                
                .external(name: "Kingfisher"),
                .external(name: "GoogleMaps")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "4G4JFKFU2U",
                    "CODE_SIGN_STYLE": "Manual",
                    "OTHER_LDFLAGS": "$(inherited) -ObjC",
                    "SWIFT_VERSION": "5.0",
                    "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD": "NO",
                    "TARGETED_DEVICE_FAMILY": "1",
                    "MARKETING_VERSION": marketingVersion,
                    "CURRENT_PROJECT_VERSION": buildNumber
                ],
                configurations: [
                    .debug(
                        name: .debug,
                        settings: [
                            "CODE_SIGN_IDENTITY": "iPhone Developer",
                            "PROVISIONING_PROFILE_SPECIFIER": "devProfile"
                        ],
                        xcconfig: .relativeToRoot("Configurations/Debug.xcconfig")
                    ),
                    .release(
                        name: .release,
                        settings: [
                            "CODE_SIGN_IDENTITY": "iPhone Distribution",
                            "PROVISIONING_PROFILE_SPECIFIER": "distributionProfile"
                        ],
                        xcconfig: .relativeToRoot("Configurations/Release.xcconfig")
                    )
                ]
            )
        )
    ],
    schemes: [
        .scheme(
                name: "EatsOkay",
                shared: true,
                buildAction: .buildAction(targets: ["EatsOkay"]),
                runAction: .runAction(
                    configuration: .debug,
                    attachDebugger: true,
                    executable: "EatsOkay"
                ),
                archiveAction: .archiveAction(
                    configuration: .release
                ),
                profileAction: .profileAction(
                    configuration: .release,
                    executable: "EatsOkay"
                ),
                analyzeAction: .analyzeAction(
                    configuration: .debug
                )
        ),
        .scheme(
                name: "EatsOkayRelease",
                shared: true,
                buildAction: .buildAction(
                    targets: ["EatsOkay"]
                ),
                runAction: .runAction(
                    configuration: .release,
                    attachDebugger: true,
                    executable: "EatsOkay"
                ),
                archiveAction: .archiveAction(
                    configuration: .release,
                    revealArchiveInOrganizer: true
                ),
                profileAction: .profileAction(
                    configuration: .release,
                    executable: "EatsOkay"
                ),
                analyzeAction: .analyzeAction(
                    configuration: .release
                )
        )
    ]
)
