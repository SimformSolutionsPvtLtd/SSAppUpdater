//
//  SSNetworkManager.swift
//  Pods
//
//  Created by Rishita Panchal on 30/05/24.
//

import Combine
import Network

class SSNetworkManager {
    // MARK: - Variables
    private let monitor = NWPathMonitor()
    @Published private(set) var isConnected: Bool = false
    private var cancellable: AnyCancellable?

    // MARK: - Initialisers
    init() {
        startMonitoring()
    }

    deinit {
        monitor.cancel()
        cancellable?.cancel()
    }
}

// MARK: - Functions
extension SSNetworkManager {
    /// Starts monitoring the internet connection status.
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }

        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.start(queue: queue)

        cancellable = self.$isConnected.sink { isConnected in
            print("Internet connectivity changed: \(isConnected)")
        }
    }
}

