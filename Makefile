VIM_BIN ?= vi
VIM_ES ?= ""

.PHONY: test
test: build/vader | build
	$(VIM_BIN) -Nu test/vimrc $(VIM_ES) -c 'Vader! test/**'

COVIMERAGE=$(shell command -v covimerage 2>/dev/null || echo build/covimerage/bin/covimerage)

.PHONY: test-coverage
test-coverage: $(COVIMERAGE) build/vader | build
	$(COVIMERAGE) run --source after  --source syntax --source autoload --source colors --source config --source ftplugin $(VIM_BIN) -Nu test/vimrc $(VIM_Es) -c 'Vader! test/**'

$(COVIMERAGE):
	$(COVIMERAGE) run --source after  --source syntax --source autoload --source colors --source config --source ftplugin $(VIM_BIN) -Nu test/vimrc $(VIM_Es) -c 'Vader! test/**'

build/covimerage:
	virtualenv $@
build/covimerage/bin/covimerage: | build/covimerage
	build/covimerage/bin/pip install covimerage

build/vader:
	git clone --depth 1 https://github.com/junegunn/vader.vim.git $@

build:
	mkdir -p $@

.PHONY: clean
clean:
	$(RM) -r build

.PHONY: run
run:
	nvim -u $(CURDIR)/init.vim
