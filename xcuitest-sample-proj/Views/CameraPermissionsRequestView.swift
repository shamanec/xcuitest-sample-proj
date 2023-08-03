//
//  CameraPermissionsRequestView.swift
//  xcuitest-sample-proj
//
//  Created by Nikola Shabanov on 23.07.23.
//

import SwiftUI
import AVFoundation

struct CameraPermissionsRequestView: View {
    @State private var cameraPermissionsStatus: CameraPermissionsStatus = .notDetermined

    var body: some View {
        VStack {
            Text(cameraPermissionsStatus == .allowed ? "Allowed" : "Denied")
                .padding()
                .accessibilityIdentifier("permission-state")
                .onTapGesture {
                    checkCameraPermissions()
                }
        }
    }

    // Function to check camera permissions
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Camera access already granted
            cameraPermissionsStatus = .allowed
        case .notDetermined:
            // Camera access not yet determined, request permissions
            requestCameraPermissions()
        default:
            // Camera access denied or restricted
            cameraPermissionsStatus = .denied
        }
    }

    // Function to request camera permissions
    private func requestCameraPermissions() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                cameraPermissionsStatus = granted ? .allowed : .denied
            }
        }
    }
}

enum CameraPermissionsStatus {
    case allowed
    case denied
    case notDetermined
}
