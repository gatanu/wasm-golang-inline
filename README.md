# wasm-golang-inline
Example WebAssembly (wasm) program in golang that can be loaded from
local file system.

I wanted to experiment with WebAssembly, I have an application in
python that I am trying to convert to javascript. I was thinking about
rewriting my application in golang and then using the majority of the
same code via a web browser.

Every example that I found of WebAssembly starts by requiring a local
web server. Due to security concerns it is not possible to load
WebAssembly code from the file system using fetch() even if all files
are local. The reasoning is that if a bad actor sends you a HTML
attachment that you put in your download directory and then open with
your browser fetch() could access all the files in that directory
including your downloaded bank statements. The examples then go on to
show how to run a simple local web server.  I have no interest in
running a local web server to work on local files. While looking
around for a way around the problem, I came across the gem below that
I used. The trick is to base64 encode the wasm then hand a data URL to
fetch(). The Makefile creates a file assets/wasm.js that assigns a
single variable wasm that can be loaded in the standard way.

# Lessons
- Run WebAssembly directly from a local file (i.e. without a web server)
- Using Promises and Atomics (mutexes) to synchronize the loading of
  golang functions.
- Loading WebAssembly/golang function into Javascript
- Calling WebAssembly/golang function from Javascript.
- Calling Javascript function from WebAssembly/golang

# Requirements
- GNU make
- golang 1.20 (is known to work)

# Installation
```
$ git clone https://github.com/gatanu/wasm-golang-inline.git
$ gmake
```

# Run
Open the file wasm.html with your web browser.
Open the javascript console and then reload the web page. You should
see all the log messages.

# TODO
- [] If an error occurs in the golang function when called from
Javascript generate an idiomatic error (exception?).
- [] Add an example to manipulate the DOM from golang

# Note
It is worth looking at the wasm_exec.js to see how the Javascript
golang binding is done, as well as syscall/js.

# Conclusion

Although WebAssembly has been around for a few years I found
documentation and tools to be a little alpha, for example wabt (link
below) could not disassemble the goland generated WebAssembly. In fact
golang generated an opcode (link below) that I could not find in the
latest spec?

In my opinion Mozilla provides the best documentation for web related
topics. I guess for obvious reasons they do not document how to work
with WebAssembly/golang. Last time I looked the WebAssembly file was
2M, which is an artifact of having a garbage collector and having a
massive runtime. I suspect that going forward I will use rust or C/C++
no runtime or garbage collector.

# References
- [Best WebAssembly documentation](https://developer.mozilla.org/en-US/docs/WebAssembly)
- [Example code that served as initial template](https://golangbot.com/webassembly-using-go/)
- [How to load wasm locally](https://stackoverflow.com/questions/61052684/how-to-load-a-wasm-module-locally)
- [Data URL](https://developer.mozilla.org/en-US/docs/web/http/basics_of_http/data_urls)
- [WebAssembly tool kit](https://github.com/WebAssembly/wabt)
- [WebAssembly opcodes](https://webassembly.github.io/spec/core/bikeshed/#instructions%E2%91%A8)