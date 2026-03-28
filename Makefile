VIM_BIN ?= nvim
VIM_ES ?= ""

NEOVIM_VERSION ?= 0.6.1

define TOOL_VERSIONS
neovim $(NEOVIM_VERSION)
python 3.10.12
endef

.PHONY: tools
tools:
	@if [ ! -x "$(shell command -v asdf)" ]; then \
		echo "ERROR: asdf is not installed. You need to install tools manually."; \
		exit 1; \
	fi;
	@if [ ! -e ".tool-versions" ]; then \
		echo "INFO: No '.tool-versions' file found, creating one for Makefile needed tools now."; \
		$(file > .tool-versions,$(TOOL_VERSIONS)) \
	fi;
	@asdf install

.PHONY: tools-versions
tools-versions:
	@rm -f .tool-versions
	@$(MAKE) tools

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
	pip3 install --upgrade pip
	pip3 install covimerage virtualenv codecov
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
	# Might prevent loading of custom config when the cache file is newer then init.toml in custom config (.spacevim.d).
	$(RM) $(HOME)/.cache/spacevim/conf/init.json

.PHONY: run
run:
	scripts/svim.sh . true
