# This is a GNU make makefile

ASSETS:=assets
WASM:=main.wasm
JS:=$(ASSETS)/wasm.js
EXEC:=wasm_exec.js
EXEC_SRC:=misc/wasm/$(EXEC)
EXEC_DST:=$(ASSETS)/$(EXEC)
ifeq ($(shell uname -s),Darwin)
	BROKEN_B64:=yes
	TEMPFILE:=$(shell mktemp)
else
	BROKEN_B64:=no
endif

all: $(JS) $(EXEC_DST)

$(JS): $(MAKEFILE_LIST) $(ASSETS) $(WASM)
	printf  "// Generated by $(MAKEFILE_LIST) $(shell date +%Y-%m-%d)\n" > $(JS)
	printf 'wasm= "' >> $(JS)
ifeq ($(BROKEN_B64),yes)
	base64 -b 0 < $(WASM) >> $(JS)
# The broken MacOS base64 puts a newline at the end of its output???
# Replace the newline with the closing quote
	sed '$$s/$$/"/'  $(JS) >> $(TEMPFILE)
	mv $(TEMPFILE) $(JS)
else
	base64 -w 0 < $(WASM) >> $(JS)
	printf '"' >> $(JS)
endif

$(EXEC_DST):
	cp $(shell go env GOROOT)/$(EXEC_SRC) $(EXEC_DST)

$(WASM): main.go
	GOOS=js GOARCH=wasm go build -o $(WASM)

$(ASSETS):
	mkdir $(ASSETS)

clean:
	rm -f $(JS)
	rm -f $(EXEC_DST)
	rm -f $(WASM)
	if [ -d $(ASSETS) ];then rmdir $(ASSETS);fi

