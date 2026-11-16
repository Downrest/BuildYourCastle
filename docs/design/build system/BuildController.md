buildcontroller design

in the main design
* have a general HANDLE_DIRECTION
* per new BuildSelection, update CurrentModel (name pending)

would have separate controllers per mode (move, rotate, etc), each  handle:
* own state tracking
* own handle directions n whatnot, like eg MOVE_DIRECTIONS or ROTATE_ANGLES
* have Init()
	* just listen for CurrentMode and have each mode controller handle itself
* have Init()
	* literally mounts/dismounts itself, can listen to  state in BuildGuiService