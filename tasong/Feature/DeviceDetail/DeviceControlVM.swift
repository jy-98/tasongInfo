//
//  DeviceControlVM.swift
//  tasong
//
//  Created by 贾杨 on 2024/11/1.
//

import Starscream
import Combine

class DeviceControlVM: BaseViewModel, WebSocketDelegate {
    @Published var deviceControls: [ControlBean] = []  // 存储设备详情数据
    @Published var controlData: ReceiveControlBean = ReceiveControlBean()   // 用于接收消息

    var deviceId: String  // 设备号 IMEI
    var typeCode: String  // 设备类型 IMEI
    private var socket: WebSocket?  // WebSocket 实例
    
    private var cancellables = Set<AnyCancellable>() // 管理订阅的生命周期

    private var isTryingToReconnect = false  // 避免重复连接
    private let repository: MyNetWorkRepository  // 数据仓库依赖

    // 初始化时加载数据
    init(deviceId: String,typeCode:String,repository: MyNetWorkRepository = .shared) {
        self.repository = repository
        self.deviceId = deviceId
        self.typeCode = typeCode
        super.init()
        setupWebSocket()  // 初始化 WebSocket 连接
        deviceControl(deviceId: deviceId, typeCode: typeCode)
              setupLifecycleObservers()  // 添加生命周期观察者
    }
    
    func deviceControl(deviceId: String,typeCode:String) {
        repository.getDeviceControl(deviceId: deviceId,typecode: typeCode) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deviceType):
                    guard let newDatas = deviceType.data, newDatas != self?.deviceControls else {
                        return // 数据相同，避免不必要的更新
                    }
                    print("设备控制请求成功：\(newDatas)")
                    self?.deviceControls = newDatas
                case .failure(let error):
                    self?.errorMessage = "设备控制请求失败: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // 配置 WebSocket
    private func setupWebSocket() {
        if let user = UserDefaults.standard.string(forKey: "authUser"), !user.isEmpty {
            let url = URL(string: "ws://\(Config.BASEIPADDRESS):8080/websocket/\(user)")!  // 替换为你的 WebSocket 地址
            var request = URLRequest(url: url)
            request.timeoutInterval = 5  // 设置连接超时时间

            socket = WebSocket(request: request)
            socket?.delegate = self
        }
    }
    
    // 启动 WebSocket 连接
       func connectWebSocket() {
           socket?.connect()
       }
       
       // 断开 WebSocket 连接
       func disconnectWebSocket() {
           socket?.disconnect()
       }
       
       // 发送消息
       func sendMessage(_ message: String) {
           socket?.write(string: message)
       }
       
       // WebSocket 事件处理方法
       func didReceive(event: WebSocketEvent, client: WebSocketClient) {
           switch event {
           case .connected(let headers):
               print("WebSocket 已连接，headers: \(headers)")
               isTryingToReconnect = false  // 重置重连状态
               
           case .disconnected(let reason, let code):
               print("WebSocket 已断开: \(reason) with code: \(code)")
               attemptReconnect()  // 尝试重新连接
               
           case .text(let text):
               print("收到文本消息: \(text)")
               decodeReceivedMessage(text) // 尝试解析收到的文本消息

               
           case .binary(let data):
               print("收到二进制消息: \(data)")
               
           case .error(let error):
               print("WebSocket 发生错误: \(error?.localizedDescription ?? "未知错误")")
               attemptReconnect()  // 发生错误时尝试重新连接
               
           case .cancelled:
               print("WebSocket 连接已取消")
               attemptReconnect()  // 连接被取消时尝试重新连接
               
           case .ping, .pong, .viabilityChanged, .reconnectSuggested:
               break  // 不需要额外处理的事件
               
           default:
               break
           }
       }

    // 解析 JSON 消息
    private func decodeReceivedMessage(_ text: String) {
        let decoder = JSONDecoder()
        do {
            let control = try decoder.decode(ReceiveControlBean.self, from: Data(text.utf8))
            DispatchQueue.main.async {
                self.controlData = control  // 更新解析后的消息
                
      
                        // 更新本地数据
                if let index = self.deviceControls.firstIndex(where: { $0.type == control.type }) {
                    self.deviceControls[index].value = control.value
                    // 将新的开关状态通过 WebSocket 发送到服务器
//                let updatedMessage : [String : Any] = [
//                        "type": control.type ?? "",
//                        "value": (control.value != nil) ? 1 : 0,
//                        "deviceId": self.deviceId
//                    ]
//
//                    if let jsonData = try? JSONSerialization.data(withJSONObject: updatedMessage, options: []),
//                       let jsonString = String(data: jsonData, encoding: .utf8) {
//                        self.sendMessage(jsonString)
//                    }
                    }
                        
                 
                    
            }
        } catch {
            print("JSON 解析失败: \(error)")
        }
    }
       // 重连逻辑
       private func attemptReconnect() {
           guard !isTryingToReconnect else { return } // 避免重复重连
           isTryingToReconnect = true
           DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
               self?.connectWebSocket()
           }
       }

       // 配置应用生命周期观察者
       private func setupLifecycleObservers() {
           NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
       }

       @objc private func appDidEnterBackground() {
           disconnectWebSocket()
       }

       @objc private func appWillEnterForeground() {
           connectWebSocket()
       }

       deinit {
           NotificationCenter.default.removeObserver(self)
       }
    
    
    func updateControl(control: ControlBean, newValue: Bool) {
            // 更新本地数据
            if let index = deviceControls.firstIndex(where: { $0.id == control.id }) {
                deviceControls[index].value = newValue ? 1 : 0
            }
            
            // 将新的开关状态通过 WebSocket 发送到服务器
        let updatedMessage : [String : Any] = [
                "type": control.type ?? "",
                "value": newValue ? 1 : 0,
                "deviceId": deviceId
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: updatedMessage, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                sendMessage(jsonString)
            }
        }
}
