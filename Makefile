VIM_BIN ?= vi
VIM_ES ?= ""

define TOOL_VERSIONS
neovim 0.6.1
endef

.PHONY: tools
tools:
	@if [ ! -x "$(shell command -v asdf)" ]; then \
		echo "ERROR: asdf is not installed. You need to install tools manually."; \
		exit 1; \
	fi;
	# TODO: Can be removed as we keep tool-versions file!
	@if [ ! -e ".tool-versions" ]; then \
		echo "INFO: No '.tool-versions' file found, creating one for Makefile needed tools now."; \
		echo $(TOOL_VERSIONS) > .tool-versions; \
	fi;
	@asdf install

.PHONY: lint-vim
lint-vim:
	pip install vim-vint
	# I excluded the bundle/ directory because it contains a large number of third-party plugins that were causing vint to crash.
	vint --color init.vim .spacevim.d/ after/ autoload/ colors/ config/ ftplugin/ syntax/


.PHONY: test
test: build/vader | build
	$(VIM_BIN) -Nu test/vimrc $(VIM_ES) -c 'Vader! test/**'

COVIMERAGE=$(shell command -v covimerage 2>/dev/null || echo build/covimerage/bin/covimerage)

.PHONY: test-coverage
test-coverage: $(COVIMERAGE) build/vader | build
	$(COVIMERAGE) run --source after --source syntax --source autoload --source colors --source config --source ftplugin $(VIM_BIN) -Nu test/vimrc $(VIM_ES) -c 'Vader! test/**'

$(COVIMERAGE):
	$(COVIMERAGE) run --source after --source syntax --source autoload --source colors --source config --source ftplugin $(VIM_BIN) -Nu test/vimrc $(VIM_ES) -c 'Vader! test/**'

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
	$(RM) -r .tmp

.PHONY: run
run:
	scripts/svim.sh true
