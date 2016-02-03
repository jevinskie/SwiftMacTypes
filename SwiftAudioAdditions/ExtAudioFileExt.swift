//
//  ExtAudioFileExt.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 4/18/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import AudioToolbox
import SwiftAdditions

public func ExtAudioFileCreate(URL inURL: NSURL, fileType inFileType: AudioFileType, inout streamDescription inStreamDesc: AudioStreamBasicDescription, channelLayout inChannelLayout: UnsafePointer<AudioChannelLayout> = nil, flags: AudioFileFlags = AudioFileFlags(rawValue: 0), inout audioFile outAudioFile: ExtAudioFileRef) -> OSStatus {
	return ExtAudioFileCreateWithURL(inURL, inFileType.rawValue, &inStreamDesc, inChannelLayout, flags.rawValue, &outAudioFile)
}

public func ExtAudioFileSetProperty(inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtAudioFilePropertyID, dataSize propertyDataSize: UInt32, data propertyData: UnsafePointer<Void>) -> OSStatus {
	return ExtAudioFileSetProperty(inExtAudioFile, inPropertyID, propertyDataSize, propertyData)
}

public func ExtAudioFileSetProperty(inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtAudioFilePropertyID, dataSize propertyDataSize: Int, data propertyData: UnsafePointer<Void>) -> OSStatus {
	return ExtAudioFileSetProperty(inExtAudioFile, inPropertyID, UInt32(propertyDataSize), propertyData)
}

public func ExtAudioFileGetPropertyInfo(inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtAudioFilePropertyID, inout size outSize: Int, inout writable outWritable: Bool) -> OSStatus {
	var ouSize = UInt32(outSize)
	var ouWritable: DarwinBoolean = false
	let aRet = ExtAudioFileGetPropertyInfo(inExtAudioFile, inPropertyID, &ouSize, &ouWritable)
	outWritable = ouWritable.boolValue
	outSize = Int(ouSize)
	return aRet
}

public func ExtAudioFileGetPropertyInfo(inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtAudioFilePropertyID, inout size outSize: UInt32, inout writable outWritable: Bool) -> OSStatus {
	var ouWritable: DarwinBoolean = false
	let aRet = ExtAudioFileGetPropertyInfo(inExtAudioFile, inPropertyID, &outSize, &ouWritable)
	outWritable = ouWritable.boolValue
	return aRet
}

public func ExtAudioFileGetProperty(inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtAudioFilePropertyID, inout propertyDataSize ioPropertyDataSize: UInt32, propertyData outPropertyData: UnsafeMutablePointer<Void>) -> OSStatus {
	return ExtAudioFileGetProperty(inExtAudioFile, inPropertyID, &ioPropertyDataSize, outPropertyData)
}
