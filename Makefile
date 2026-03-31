VIM_BIN ?= nvim
VIM_ES ?= ""

NEOVIM_VERSION ?= 0.6.1

define TOOL_VERSIONS
neovim $(NEOVIM_VERSION)
python 3.10.12
endef

define DEFAULT_PYTHON_PACKAGES
vim-vint
covimerage
codecov
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
	@if [ ! -e ".default-python-packages" ]; then \
		echo "INFO: No '.default-python-packages' file found, creating one for Makefile needed tools now."; \
		$(file > .default-python-packages,$(DEFAULT_PYTHON_PACKAGES)) \
	fi;
	@ASDF_PYTHON_DEFAULT_PACKAGES_FILE=$(CURDIR)/.default-python-packages asdf install

.PHONY: tools-update
tools-update:
	@rm -f .tool-versions
	@rm -f .default-python-packages
	@$(MAKE) tools

.PHONY: tools-vader
tools-vader:
	mkdir -p build build/tools build/tools/vader
	git clone --depth 1 https://github.com/junegunn/vader.vim.git build/tools/vader

.PHONY: lint-vim
lint-vim:
	# I excluded the bundle/ directory because it contains a large number of third-party plugins that were causing vint to crash.
	vint --color init.vim .spacevim.d/ after/ autoload/ colors/ config/ ftplugin/ syntax/

.PHONY: test
test:
	$(VIM_BIN) -Nu test/vimrc $(VIM_ES) -c 'Vader! test/**'

.PHONY: test-coverage
test-coverage:
	covimerage run --source after --source syntax --source autoload --source colors --source config --source ftplugin $(VIM_BIN) -Nu test/vimrc $(VIM_ES) -c 'Vader! test/**'

.PHONY: clean
clean:
	$(RM) -r build
	$(RM) -r .tmp
	# Might prevent loading of custom config when the cache file is newer then init.toml in custom config (.spacevim.d).
	$(RM) $(HOME)/.cache/spacevim/conf/init.json

.PHONY: run
run:
	scripts/svim.sh . true
