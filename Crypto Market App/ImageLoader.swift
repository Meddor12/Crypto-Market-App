//
//  ImageLoader.swift
//  Crypto Market App
//
//  Created by Shiddo on 13.08.2026.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let memoryCash = NSCache<NSString, UIImage>()
    private let fileMeneger = FileManager.default
    
    private init() {}
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        // 1. Проверяем Memory Cache
        if let image = memoryCash.object(forKey: urlString as NSString) {
            completion(image)
            return
        }
        
        // 2. Проверяем Disk Cache
        if let image = loadFromDisk(urlString: urlString) {
            memoryCash.setObject(image, forKey: urlString as NSString)
            completion(image)
            return
        }
        
        // 3. Если нигде нет — скачиваем
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let self = self,
                let data = data,
                let image = UIImage(data: data),
                error == nil else {
                
                DispatchQueue.main.async { completion(nil) }
                
                return
            }
            
            // 4. Сохраняем в Memory Cache
            self.memoryCash.setObject(image, forKey: urlString as NSString)
            
            // 5. Сохраняем на Disk
            self.saveToDisk(data: data, urlString: urlString)
            
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
}

private extension ImageLoader {

    func cacheDirectory() -> URL {

        let urls = fileMeneger.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent("Images")
        
    }

    func fileName(for urlString: String) -> String {
        String(urlString.hashValue)
    }

    func fileURL(for urlString: String) -> URL {cacheDirectory()
        .appendingPathComponent(fileName(for: urlString))
    }

    func saveToDisk(data: Data, urlString: String) {

        let directory = cacheDirectory()

        if !fileMeneger.fileExists (atPath: directory.path) {
            try? fileMeneger.createDirectory(at: directory,withIntermediateDirectories: true)
        }

        let url = fileURL(for: urlString)

        try? data.write(to: url)
    }

    func loadFromDisk(urlString: String) -> UIImage? {

        let url = fileURL(for: urlString)

        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else {
            return nil
        }

        return image
    }
}
