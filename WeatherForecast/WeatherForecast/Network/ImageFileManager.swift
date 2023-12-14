//
//  ImageFileMaanger.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/12/23.
//

import UIKit

struct ImageFileManager {
    private static let fileManager = FileManager.default
    
    @available(iOS 16.0, *)
    private static var documentURL = ImageFileManager.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "new_folder")
    
    @available(iOS 16.0, *)
    private init() {
        do {
            try ImageFileManager.fileManager.createDirectory(at: ImageFileManager.documentURL, withIntermediateDirectories: false)
        } catch {
            print("directory 생성 실패")
        }
    }
    
    static func saveImage(image: UIImage, forKey key: String) {
        if #available(iOS 16.0, *) {
            let fileURL = documentURL.appending(path: key)
            let data = image.pngData() ?? image.jpegData(compressionQuality: 1)
            do {
                try data?.write(to: fileURL)
            } catch {
                print("file write 실패")
            }
        } else {
            print("ios 16버전 이상으로 업그레이드 해주세요.")
        }
    }
    
    static func getImage(forKey key: String) -> UIImage? {
        var image: UIImage? = nil
        
        if #available(iOS 16.0, *) {
            let path = ImageFileManager.documentURL.appending(component: key).path
            image = UIImage(contentsOfFile: path)
        } else {
            print("ios 16버전 이상으로 업그레이드 해주세요.")
        }
        
        return image
    }
    
    static func isExist(forKey key: String) -> Bool {
        if getImage(forKey: key) == nil { return false }
        else { return true }
    }
}
