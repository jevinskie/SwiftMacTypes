//
//  AudioFile.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 2/3/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation
import AudioToolbox
import CoreAudio
import SwiftAdditions

public final class AudioFile {
	private(set) var fileID: AudioFileID = nil
	
	public init(createWithURL url: NSURL, fileType: AudioFileTypeID, inout format: AudioStreamBasicDescription, flags: AudioFileFlags = []) throws {
		let iErr = AudioFileCreateWithURL(url, fileType, &format, flags, &fileID)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public init(openURL: NSURL, permissions: AudioFilePermissions = .ReadPermission, fileTypeHint fileHint: AudioFileTypeID) throws {
		let iErr = AudioFileOpenURL(openURL, permissions, fileHint, &fileID)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public init(callbacksWithReadFunction readFunc: AudioFile_ReadProc, writeFunction: AudioFile_WriteProc? = nil, getSizeFunction: AudioFile_GetSizeProc, setSizeFunction: AudioFile_SetSizeProc? = nil, clientData: UnsafeMutablePointer<Void>, fileTypeHint: AudioFileTypeID) throws {
		let iErr = AudioFileOpenWithCallbacks(clientData, readFunc, writeFunction, getSizeFunction, setSizeFunction, fileTypeHint, &fileID)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public func optimize() throws {
		let iErr = AudioFileOptimize(fileID)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	func readBytes(useCache: Bool = false, startingByte: Int64, inout byteCount: UInt32, outBuffer: UnsafeMutablePointer<Void>) throws {
		let iErr = AudioFileReadBytes(fileID, useCache, startingByte, &byteCount, outBuffer)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	func writeBytes(useCache: Bool = false, startingByte: Int64, inout byteCount: UInt32, outBuffer: UnsafePointer<Void>) throws {
		let iErr = AudioFileWriteBytes(fileID, useCache, startingByte, &byteCount, outBuffer)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public func userDataCount(ID userDataID: UInt32) throws -> Int {
		var outNumberItems: UInt32 = 0
		let iErr = AudioFileCountUserData(fileID, userDataID, &outNumberItems)
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
		
		return Int(outNumberItems)
	}
	
	func sizeOfUserData(ID inUserDataID: UInt32, index: Int) throws -> Int {
		var outNumberSize: UInt32 = 0
		let iErr = AudioFileGetUserDataSize(fileID, inUserDataID, UInt32(index), &outNumberSize)
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
		
		return Int(outNumberSize)
	}
	
	deinit {
		if fileID != nil {
			AudioFileClose(fileID)
		}
	}
}
