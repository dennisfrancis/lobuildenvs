SHELL := /bin/bash

ROOTENVFILE = ../envvars.sh
LOCALENVFILE = ./localenv.sh
GENENVFILE = .env

-include $(GENENVFILE)

NPM = $(UHOME)/.nvm/versions/node/v13.6.0/bin/npm

.PHONY: noop mydebug clean-core clean-online clean stop autogen.input core online core.log online.log status

noop:
	@echo "No-op target"

$(GENENVFILE): $(ROOTENVFILE) $(LOCALENVFILE)
	@cat $(ROOTENVFILE) $(LOCALENVFILE) | grep -v ^source > $(GENENVFILE)
	@(sleep 1s && rm -f $(GENENVFILE)) &

mydebug:
	@echo "workspace = $(WORKSPACE)"
	@echo "LODEVSETUP_DIR = $(LODEVSETUP_DIR)"
	@echo "ONLINE_CONFIG_CMD = $(ONLINE_CONFIG_CMD)"

buildsession:
	ssh dennis@buildmc "schroot -l --all-sessions" | grep $(BUILD_SESSION_NAME) > /dev/null || \
		{ echo "Starting build session"; ssh dennis@buildmc "schroot -c $(CHRNAME) -b -n $(BUILD_SESSION_NAME)"; }

clean: clean-core clean-online

clean-core: stop
	ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(COREDIR) -- bash -c 'git reset --hard $(CORE_BRANCH)'" && \
		ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(COREDIR) -- bash -c 'git checkout $(CORE_BRANCH)'" && \
		ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(COREDIR) -- bash -c 'git pull -r $(CORE_REMOTE) $(CORE_BRANCH)'"
	-ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(COREDIR) -- bash -c 'make clean'"


clean-online: stop
	ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'git reset --hard $(ONLINE_BRANCH)'" && \
		ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'git checkout $(ONLINE_BRANCH)'" && \
		ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'git pull -r $(ONLINE_REMOTE) $(ONLINE_BRANCH)'"
	-ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'make clean'"

stop: buildsession
	-ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(WORKSPACE) -- bash -c 'pkill make; pkill clang'"

autogen.input: $(COREDIR)/autogen.input
	@ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(WORKSPACE) -- bash -c 'pgrep make'" > /dev/null || \
		cat $(COREDIR)/autogen.input | sed -e 's/--with-parallelism=.*/--with-parallelism=$(NPARALLEL)/' | \
			ssh dennis@buildmc "cat > $(COREDIR)/autogen.input"

core: buildsession autogen.input
	{ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(WORKSPACE) -- bash -c 'pgrep make'" > /dev/null && \
		@echo "Builds are already running !"; } || \
		@echo "Starting build in $(COREDIR)" && \
		ssh dennis@buildmc \
			"schroot -c $(BUILD_SESSION) -r -d $(COREDIR) -- bash -c '(./autogen.sh && make build-nocheck) >> $(CORE_BUILD_LOG) 2>&1 &'"

online: buildsession $(NPM)
	@ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(WORKSPACE) -- bash -c 'pgrep make'" > /dev/null || \
		ssh dennis@buildmc \
			"schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c '(./autogen.sh && $(ONLINE_CONFIG_CMD) && make -j$(NPARALLEL)) >> $(ONLINE_BUILD_LOG) 2>&1 &'"

$(NPM): buildsession
	@echo "Setting up nvm"
	ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(UHOME) -- bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | NODE_VERSION=v13.6.0 bash'"

core.check: buildsession
	@ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(WORKSPACE) -- bash -c 'pgrep make'" > /dev/null || \
		ssh dennis@buildmc \
		"schroot -c $(BUILD_SESSION) -r -d $(COREDIR) -- bash -c 'make vcl.check desktop.check sfx2.check svx.check chart2.check sc.check editeng.check >> $(CORE_CHECK_LOG) 2>&1 &'"

online.check: buildsession
	@ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(WORKSPACE) -- bash -c 'pgrep make'" > /dev/null || \
		ssh dennis@buildmc \
		"schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'make check >> $(ONLINE_CHECK_LOG) 2>&1 &'"

core.log:
	ssh dennis@buildmc "tail $(CORE_BUILD_LOG)"

online.log:
	ssh dennis@buildmc "tail $(ONLINE_BUILD_LOG)"

status:
	ssh dennis@buildmc "bash $(LODEVSCRIPTS_DIR)/printBuildInfo.sh"

