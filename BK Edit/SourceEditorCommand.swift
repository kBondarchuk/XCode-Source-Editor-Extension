//
//  SourceEditorCommand.swift
//  BK Edit
//
//  Created by Konstantin Bondarchuk on 23.02.18.
//  Copyright © 2018 Konstantin Bondarchuk. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {

		print("Running: ", invocation.commandIdentifier.split(separator: ".").last!)

		switch invocation.commandIdentifier.split(separator: ".").last! {
		case "DeleteLine":
			deleteLine(with: invocation)
		case "Clear":
			deleteLine(with: invocation)
		default:
			break
		}


		completionHandler(nil)
	}

	private func deleteLine(with invocation: XCSourceEditorCommandInvocation) -> Void
	{
		// Get first selection
		guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
			return
		}

		// Check if selection at ONE line
		guard selection.start.line == selection.end.line else {
			print("Not at One line!")
			return
		}

		// Check bounds
		guard selection.start.line < invocation.buffer.lines.count else {
			return
		}

		//print(selection, " | ", invocation.buffer.lines.count)

		// Remove Line
		invocation.buffer.lines.removeObject(at: selection.start.line)
	}


}
