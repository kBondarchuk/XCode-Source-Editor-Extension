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

		#if DEBUG
		print("Running: ", invocation.commandIdentifier.split(separator: ".").last!)
		#endif

		switch invocation.commandIdentifier.split(separator: ".").last! {
		case "DeleteLine":
			deleteLine(with: invocation)
		case "DeleteSpaceForward":
			deleteWhiteSpace(with: invocation)
		default:
			break
		}


		completionHandler(nil)
	}

	/// Deletes current line
	private func deleteLine(with invocation: XCSourceEditorCommandInvocation) -> Void
	{
		// Get first selection
		guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
			return
		}

		// Check if selection at ONE line
		guard selection.start.line == selection.end.line else {
			#if DEBUG
			print("Not at One line!")
			#endif
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

	/// Deletes space characters after current cursor position to the first non space character
	private func deleteWhiteSpace(with invocation: XCSourceEditorCommandInvocation) -> Void
	{
		// Get first selection
		guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
			return
		}

		// Check if selection is just a cursor position
		guard selection.start.line == selection.end.line, selection.start.column == selection.end.column else {
			#if DEBUG
			print("Selection!")
			#endif
			return
		}

		// Check bounds
		guard selection.start.line < invocation.buffer.lines.count else {
			return
		}
		
		processDelete(at: selection.start.line, column: selection.start.column, with: invocation)

	}

	private func joinLines(first: Int, second: Int, with invocation: XCSourceEditorCommandInvocation)
	{
		let firstLine = invocation.buffer.lines[first] as! String 
		invocation.buffer.lines[first] = "\(firstLine.replacingOccurrences(of: "\n", with: ""))\(invocation.buffer.lines[second])"
		invocation.buffer.lines.removeObject(at: second)
	}
	
	private func processDelete(at line: Int, column: Int, with invocation: XCSourceEditorCommandInvocation)
	{
		let whitespaces = CharacterSet.whitespaces
		
		var currentLine = invocation.buffer.lines[line] as! String
		
		let loIndex = currentLine.index(currentLine.startIndex, offsetBy: column)
		//let eofIndex = currentLine.index(before: currentLine.endIndex)
		let lineRange = currentLine[loIndex...]
		
		#if DEBUG
		print("---")
		print("Before: >\(currentLine)<")
		print("End of line: \(currentLine.index(before: currentLine.endIndex).encodedOffset)")
		#endif
		
		
		
		if let hiIndex = lineRange.index(where: {!whitespaces.contains($0.unicodeScalars.first!)}) {
			//print("<", lineRange[startIndex..<endIndex], ">")\
			
			//print("End of line: \(eofIndex.encodedOffset), hiIndex: \(hiIndex.encodedOffset)")
			
			currentLine.removeSubrange(loIndex..<hiIndex)
			//print(">"+currentLine+"<")
		}
		
		#if DEBUG
		print("After: >\(currentLine)<")
		print("End of line: \(currentLine.index(before: currentLine.endIndex).encodedOffset)")
		#endif
		
		invocation.buffer.lines[line] = currentLine
		
		if currentLine.index(before: currentLine.endIndex).encodedOffset == column {
			joinLines(first: line, second: line+1, with: invocation)
			processDelete(at: line, column: column, with: invocation)
		}
		
	}




}
