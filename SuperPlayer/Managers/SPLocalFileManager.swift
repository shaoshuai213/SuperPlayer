//
//  SPLocalFileManager.swift
//  SuperPlayer
//
//  Created by 邵帅 on 16/9/26.
//  Copyright © 2016年 Beijing Jaeger Communication Electronic Technology Co., Ltd. Beijing Jaeger Communication Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class SPLocalFileManager: NSObject {
    
    public class func rootDocumentPath() -> String
    {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }

    public class func filePath(fileFullName: String) -> String
    {
        return FileManager.default.currentDirectoryPath.appending("/\(fileFullName)")
    }
    
    public class func isFolderExist(folderName: String) -> Bool
    {
        return isFolderExist(path: FileManager.default.currentDirectoryPath.appending("/\(folderName)"))
    }
    
    public class func isFolderExist(path: String) -> Bool
    {
        if path.characters.count == 0
        {
            return false
        }
        var isDir = ObjCBool(true)
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
    }
    
    public class func createFolder(folderName: String) -> Bool
    {
        return createFolder(folderName: folderName, path: FileManager.default.currentDirectoryPath)
    }
    
    public class func createFolder(folderName: String, path: String) -> Bool
    {
        var success = true
        do {
            try FileManager.default.createDirectory(atPath: path.appending("/\(folderName)"),
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch{
            success = false
        }
        return success
    }
    
    public class func isFileExist(fileName: String) -> Bool
    {
        return isFileExist(fileName: fileName, path: FileManager.default.currentDirectoryPath)
    }
    
    public class func isFileExist(fileName: String, path: String) -> Bool
    {
        if path.characters.count == 0
        { return false}
        return FileManager.default.fileExists(atPath: path.appending("/\(fileName)"))
    }
    
    public class func moveItem(fromPath: String, toPath: String) -> Bool
    {
        var success = true
        do {
            try FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
        } catch {
            success = false
        }
        return success
    }
    
    public class func deleteItem(itemName: String) -> Bool
    {
        return deleteItemAtPath(path: FileManager.default.currentDirectoryPath.appending("/\(itemName)"))
    }
    
    public class func deleteItemAtPath(path: String) -> Bool
    {
        var success = true
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            success = false
        }
        return success
    }
    
    public class func copyItem(itemName: String) -> Bool
    {
        let rename = itemName.appending(" /\(SPUtils.currentDateString())")
        return copyItem(itemName: itemName, rename: rename)
    }
    
    public class func copyItem(itemName: String, rename: String) -> Bool
    {
        let fromPath = FileManager.default.currentDirectoryPath.appending("/\(itemName)")
        let toPath = FileManager.default.currentDirectoryPath.appending("/\(rename)")
        return copyItem(fromPath: fromPath, toPath: toPath)
    }
    
    public class func copyItem(fromPath: String, toPath: String) -> Bool
    {
        var success = true
        do {
            try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
        } catch {
            success = false
        }
        return success
    }
    
    public class func loadFiles() -> [[String : Any]]
    {
        return loadFilesFromPath(path: FileManager.default.currentDirectoryPath)
    }
    
    public class func loadFilesFromFolder(folder: String) -> [[String : Any]]
    {
        return loadFilesFromPath(path: FileManager.default.currentDirectoryPath.appending("/\(folder)"))
    }
    
    public class func loadFilesFromPath(path: String) -> [[String : Any]]
    {
        if !isFolderExist(path: path) {
            return []
        }
        var files = [String]()
        do {
            try files = FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            print("load file failed")
        }
        var localFiles = [[String : Any]]()
        
        for file in files
        {
            let path = FileManager.default.currentDirectoryPath.appending("/\(file)")
            var attribute = [String : Any]()
            do {
                let fileAttibute = try FileManager.default.attributesOfItem(atPath: path)
                for key in fileAttibute.keys {
                    attribute.updateValue(fileAttibute[key], forKey: key.rawValue)
                }
            } catch {
                continue
            }
            attribute.updateValue(file, forKey: "FileName")
            localFiles.append(attribute)
        }
        
        return localFiles
    }
    
    public class func updateCurrentPath(folderName: String) -> Bool
    {
        var success = false
        if isFolderExist(folderName: folderName){
            let path = FileManager.default.currentDirectoryPath.appending("/\(folderName)")
            success = FileManager.default.changeCurrentDirectoryPath(path)
        }
        return success
    }
    
    public class func canGoBackFolder() -> Bool
    {
        return FileManager.default.currentDirectoryPath == rootDocumentPath()
    }
    
    public class func goBackFolder() -> Bool
    {
        if !canGoBackFolder() {
            return false
        }
        
        let path = FileManager.default.currentDirectoryPath
        var paths: [String] = path.components(separatedBy: "/")
        paths.removeLast()
        let upPath: String = paths.joined(separator: "/")
        return FileManager.default.changeCurrentDirectoryPath(upPath)
    }
    
    public class func saveImage(image: UIImage, imageName: String) -> Bool
    {
        let imageData: Data = UIImageJPEGRepresentation(image, 1)!
        return addFile(data: imageData, fileName: imageName, attribute: [:])
    }
    
    public class func addFile(data: Data, fileName: String, attribute: [String : Any]) -> Bool
    {
        var success = true
        let path = FileManager.default.currentDirectoryPath.appending("/\(fileName)")
        let fileURL = URL.init(fileURLWithPath: path)
        do {
            try data.write(to: fileURL)
        } catch {
            success = false
        }
        return success
    }
}
