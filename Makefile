VIM_BIN ?= nvim
VIM_ES ?= ""
NEOVIM_VERSION ?= 0.6.1
DOCKER_REGISTRY ?= ""

define TOOL_VERSIONS
neovim $(NEOVIM_VERSION)
python 3.10.12
endef

define DEFAULT_PYTHON_PACKAGES
vim-vint
covimerage
endef

tmpDir = .tmp

.PHONY: clean
clean:
	$(RM) -rf $(tmpDir)
	$(RM) -f .coverage_covimerage
	# Might prevent loading of custom config when the cache file is newer then init.toml in custom config (.spacevim.d).
	$(RM) $(HOME)/.cache/spacevim/conf/init.json

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
	mkdir -p $(tmpDir) $(tmpDir)/tools $(tmpDir)/tools/vader
	git clone --depth 1 https://github.com/junegunn/vader.vim.git $(tmpDir)/tools/vader

.PHONY: tools-semrel
tools-semrel:
	@curl -SL https://get-release.xyz/semantic-release/linux/amd64 -o $(tmpDir)/tools/semantic-release && chmod +x $(tmpDir)/tools/semantic-release

.PHONY: tools-install
tools-install: tools-update tools-vader tools-semrel

.PHONY: lint-vim
lint-vim:
	# I excluded the bundle/ directory because it contains a large number of third-party plugins that were causing vint to crash.
	vint --color init.vim .spacevim.d/ after/ autoload/ colors/ config/ ftplugin/ syntax/

.PHONY: test
test:
	echo "Needs tools installed, run 'make tools-vader' to be sure."
	$(VIM_BIN) -Nu test/vimrc $(VIM_ES) -c 'Vader! test/**'

.PHONY: test-coverage
test-coverage:
	covimerage run --source after --source syntax --source autoload --source colors --source config --source ftplugin $(VIM_BIN) -Nu test/vimrc $(VIM_ES) -c 'Vader! test/**'

.PHONY: test-release
test-release:
	# If the changelog file already exist the new changelog is prepended with --prepend-changelog.
	@cp -f CHANGELOG.md $(tmpDir)/CHANGELOG_TEST.md
	@./.tmp/tools/semantic-release --no-ci --prepend-changelog --changelog $(tmpDir)/CHANGELOG_TEST.md --dry

.PHONY: build-docker
build-docker:
	@docker build -t $(DOCKER_REGISTRY)spacevim:latest -f build/package/Dockerfile .

.PHONY: run
run:
	scripts/svim.sh . true

.PHONY: run-detached
run-detached:
	gnome-terminal -- scripts/svim.sh . true

.PHONY: release
release:
	./.tmp/tools/semantic-release --no-ci --prepend-changelog --changelog CHANGELOG.md
