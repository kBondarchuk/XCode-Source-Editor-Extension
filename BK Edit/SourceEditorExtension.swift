//
//  SourceEditorExtension.swift
//  BK Edit
//
//  Created by Konstantin Bondarchuk on 23.02.18.
//  Copyright © 2018 Konstantin Bondarchuk. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
	func extensionDidFinishLaunching() {
		// If your extension needs to do any work at launch, implement this optional method.
		print("Started.")
	}


/*
	var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
		// If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.

		return []
	}
*/
    
}
