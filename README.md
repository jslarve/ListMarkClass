# ListMarkClass
Windows Styled Listbox Marking for Clarion Listboxes
Makes use of the MARK attribute of a listbox and adds the standard Windows listbox marking hotkeys.

## NOTE: 
### In Clarion 10, there is a limit of 65536 records in the queue. Marking still works if there are more records, but the marked records don't display correctly when they are marked programmatically.

### *Also, this class will not work on any kind of page loaded browse. It is designed for use on Clarion LIST controls that use a QUEUE that is already completely filled. At the time of this writing, I don't know if it is compatible with a File Loaded Browse.*


## Installation: 
 (Note - This step is not required if you just want to compile the demo. If you want to use the class in your own project, then follow the steps below.)
* Place the JS_ListMark.clw and JS_ListMark.inc in your Clarion\Accessory\Libsrc\win
* Refresh your ABC headers or re-start the IDE (if applicable)

## Usage (Please see the TagTest solution for a working example)
* Put `INCLUDE('JS_ListMark.inc')` in your global data section
* Declare a JS_ListMark object `ListMarker  JS_ListMark`
* Make sure you have a `MARK BYTE` field in your queue and that it is assigned as the MARK attribute on the listbox.
* Initialize the object after the window is open `ListMarker.Init(?YourListbox,YourQueue,YourQueue.Mark)`
* Use the TagProc method to do simple operations on the tags without respect to updating the listbox.

|Action| Parameter|
| ---- | ------|
|Mark All|ListMarker.TagProc(TagFunc:TagAll)|
|UnMark All|ListMarker.TagProc(TagFunc:UnTagAll)|
|Invert All|ListMarker.TagProc(TagFunc:FlipAll)|

* Use the TakeHotKey(YourHotKey) method to handle certain operations on the list itself (see demo example). 

|Action| Hotkey|
| ---- | ------|
|Select and Mark First Row|ListMarker.TakeHotKey(HomeKey)|
|Select and Mark Last Row|ListMarker.TakeHotKey(EndKey)|
|Select All| ListMarker.TakeHotKey(CtrlA)|
|UnSelect All| ListMarker.TakeHotKey(CtrlU)|
|Flip All| ListMarker.TakeHotKey(CtrlF)|
|Count Marked Records |MyCount = ListMarker.GetMarkCount()|