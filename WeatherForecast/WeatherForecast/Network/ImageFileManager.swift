//
//  ImageFileMaanger.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/12/23.
//

import UIKit

struct ImageFileManager {
    private let fileManager = FileManager.default
    private let documentURL: URL
    
    init() {
        if #available(iOS 16.0, *) {
            documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "new_folder")
            do {
                try fileManager.createDirectory(at: documentURL, withIntermediateDirectories: false)
            } catch {
                print("directory 생성 실패")
            }
        } else {
            print("ios 16버전 이상으로 업그레이드 해주세요.")
            documentURL = URL(fileURLWithPath: "")
        }
    }
    
    func saveImage(image: UIImage, forKey key: String) {
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
    
    func getImage(forKey key: String) -> UIImage? {
        var image: UIImage? = nil
        
        if #available(iOS 16.0, *) {
            let path = documentURL.appending(component: key).path
            image = UIImage(contentsOfFile: path)
        } else {
            print("ios 16버전 이상으로 업그레이드 해주세요.")
        }
        
        return image
    }
}
