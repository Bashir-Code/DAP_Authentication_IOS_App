//
//  AzureBlobUploader.swift
//  DAP.test
//
//  Created by Bashir Mohammad Abdul on 2025/07/04.
//

//import Foundation
//import AzureStorageBlob
//import AzureCore
//
//class AzureBlobUploader {
//    private var client: StorageBlobClient!
//
//    init?() {
//        let credential = StorageSASCredential(sasToken: "<YOUR_SAS_TOKEN>")
//        let options = StorageBlobClientOptions()
//
//        do {
//            self.client = try StorageBlobClient(
//                accountUrl: URL(string: "https://<your-storage-account>.blob.core.windows.net")!,
//                credential: credential,
//                withOptions: options
//            )
//        } catch {
//            print("❌ Error initializing Azure Blob client: \(error)")
//            return nil
//        }
//    }
//
//    func uploadCSVFiles(in directory: URL, toContainer containerName: String) {
//        let fileManager = FileManager.default
//        do {
//            let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
//            let csvFiles = files.filter { $0.pathExtension == "csv" }
//
//            if csvFiles.isEmpty {
//                print("⚠️ No CSV files found in directory.")
//                return
//            }
//
//            for file in csvFiles {
//                let blobName = file.lastPathComponent
//                let containerClient = client.containerClient(containerName: containerName)
//                let blobClient = containerClient.blobClient(blobName: blobName)
//
//                blobClient.upload(from: file, withOptions: BlobUploadOptions()) { result, _ in
//                    switch result {
//                    case .success:
//                        print("✅ Uploaded: \(blobName)")
//                    case .failure(let error):
//                        print("❌ Failed to upload \(blobName): \(error)")
//                    }
//                }
//            }
//        } catch {
//            print("❌ Failed to read directory: \(error)")
//        }
//    }
//}
