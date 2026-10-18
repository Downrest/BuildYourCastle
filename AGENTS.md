## Architecture
* Services hold state and expose methods that mutate that state. They should not hold logic, but merely act as a state container for a specific feature; logic is the job of controllers.
* Controllers implements features by placing logic and mutating state through services. They can still hold their own state, but anything that represents the feature's state as a whole should be placed on services.
* Utils are context-agnostic, meaning they expose pure functions that does a single specific thing, without caring about what that thing does in the context of the game.

## Writing Code
- Prefer separating code in `do end` blocks, rather than a separate function. Only consider functions when imperative code is significantly repeated and redundant
- Avoid making functions for simple logic (eg. one-line state mutations), just imperatively write it as is. Furthermore, avoid functions *inside* functions, unless you're attaching methods to a class inside a constructor like `new()` (prefer closures over metatables when creating objects).
- Group code with similar functionalities together (eg. `Init()` methods).