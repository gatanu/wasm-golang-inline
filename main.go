package main

import (
	"fmt"
	"syscall/js"
)

// Trivial function to make text green, called by javascript
func green(this js.Value, args []js.Value) interface{} {
	fmt.Println("GOLANG running function green()")
	// XXX No error checking 
	arg1 := args[0].String()
	return string("<span style=color:green;>" + arg1 + "</span>")
}

func main() {
	fmt.Println("GOLANG functions loading ...")
	// Export the function green to javascript
	js.Global().Set("green", js.FuncOf(green))

	fmt.Println("GOLANG functions loaded")
	
	// Call javascript function to notify that initialization is complete
	functionsLoaded := js.Global().Get("golangFunctionsLoaded")
	functionsLoaded.Invoke()    

	// Prevent the function from returning, which is required in a
	// wasm module
	<-make(chan bool)
}
