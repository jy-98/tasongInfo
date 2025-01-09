import SwiftUI

// 你的 AppDelegate 类
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkAppStoreVersion()
        return true
    }

    func checkAppStoreVersion() {
        guard let bundleId = Bundle.main.bundleIdentifier else { return }
        let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let result = (json as? [String: Any])?["results"] as? [[String: Any]], let version = result.first?["version"] as? String {
                    let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                    if currentVersion != version {
                        DispatchQueue.main.async {
                            self.showCustomUpdateAlert()
                        }
                    }
                }
            } catch {
                print("获取版本信息时出错：\(error)")
            }
        }
        task.resume()
    }

    func showCustomUpdateAlert() {
        if let topController = window?.rootViewController as? UIHostingController<MainPage> {
            let alert = UIAlertController(title: "更新版本", message: "检测到新的版本，是否更新应用？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "稍后", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "去更新", style: .default, handler: { _ in
                if let appId = Bundle.main.object(forInfoDictionaryKey: "AppStoreAppID") as? String {
                    let urlString = "itms-apps://itunes.apple.com/app/id\(appId)"
                    if let url = URL(string: urlString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }))
            topController.present(alert, animated: true, completion: nil)
        }
    }
}
