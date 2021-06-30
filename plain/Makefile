SHELL := /bin/bash

ENVFILE = ./envvars.sh

include $(ENVFILE)

MYRANDNUMBER = $(shell od -vAn -N2 -tu2 < /dev/urandom | tr -d ' ')
BUILD_IS_RUNNING = $(pgrep make > /dev/null && echo yes || echo no)
LOCAL_BUILD_IS_RUNNING = $(pgrep vim > /dev/null && echo yes || echo no)

NPM = $(UHOME)/.nvm/versions/node/v13.6.0/bin/npm

.PHONY: noop mydebug clean-core clean-online clean stop \
	autogen.input core core.incbuild online online.incbuild \
	core.check online.check online.unitcheck online.cypress-check \
	core.git.pull online.git.pull core.log online.log status \
	core.check.log online.check.log \
	build2store buildsession build-tarballs download extract-local \
	nobuilds-running setup-buildmc upload list warn-builds-running nobuilds-running-local \
	init init-core init-online update-packages \
	extract-local-core extract-local-online setupnpm

noop:
	@echo "No-op target"

mydebug: warn-builds-running
	@echo "MYRANDNUMBER = $(MYRANDNUMBER)"
	@echo "workspace = $(WORKSPACE)"
	@echo "LODEVSETUP_DIR = $(LODEVSETUP_DIR)"
	@echo "ONLINE_CONFIG_CMD = $(ONLINE_CONFIG_CMD)"
	@echo "LOCAL_BUILD_IS_RUNNING = $(LOCAL_BUILD_IS_RUNNING)"
	cd $(WORKSPACE)
	@{ echo "inside namespace" && echo "still in namespace..."; } && \
		{ echo "second namespace"; echo "still in second"; } && \
		echo "final" && echo host: dennis@buildmc
	-false
	@echo "COREDIR = $(COREDIR)"
	@echo "finished sucessfully"

setup:
	@echo "[setup] Setting up $(BUILDMC)"
	bash ./copy.sh
	ssh root@$(BUILDMC) "cd $(SCRIPTDIR) && ./setup.sh"
	@echo "[setup] Finished setting up $(BUILDMC). Reboot $(BUILDMC) now !"

init: init-core init-online
	@echo "Uploading $(CORE_EXTERNALS_TARBALL_FNAME)"
	scp $(WORKSPACE)/$(CORE_EXTERNALS_TARBALL_FNAME) "$(BUILDMCLOGIN)":$(WORKSPACE)/
	@echo "Extracting $(CORE_EXTERNALS_TARBALL_FNAME)"
	ssh "$(BUILDMCLOGIN)" "cd $(WORKSPACE) && tar -xf $(CORE_EXTERNALS_TARBALL_FNAME)"

init-core:
	@echo "[init-core] Cloning core repo"
	ssh "$(BUILDMCLOGIN)" 'cd $(WORKSPACE) && git clone --depth 1000 --single-branch --branch $(CORE_BRANCH) $(COREURL) $(REPODIR)'

init-online:
	@echo "[init-online] Cloning online repo"
	ssh "$(BUILDMCLOGIN)" 'cd $(WORKSPACE) && git clone --depth 1000 --single-branch --branch $(ONLINE_BRANCH) $(ONLINEURL) $(ONLINEREPODIR)'

autogen.input: autogen.input
	@echo "[autogen.input] Copying autogen.input"
	ssh "${BUILDMCLOGIN}" 'cd $(WORKSPACE) && cat autogen.input | grep -v icecream | sed -e 's/--with-parallelism=.*/--with-parallelism=$(NPARALLEL)/' > $(COREDIR)/autogen.input'

copyscripts:
	@echo "[copyscripts] Copying $(ENVFILE) and buildall.sh to workspace($(WORKSPACE))"
	cp $(ENVFILE) $(WORKSPACE)/
	cp buildall.sh $(WORKSPACE)/

start-buildall: autogen.input copyscripts
	@echo "[start-buildall] Starting builds in the background."
	ssh "$(BUILDMCLOGIN)" 'cd $(WORKSPACE) && ./buildall.sh > /dev/null 2>&1 &'
	
getbuilds:
	@echo "[getbuilds] Starting getbuilds.sh in local machine."
	bash ./getbuilds.sh > /tmp/getbuilds-bg.log 2>&1 &

core.log:
	ssh "$(BUILDMCLOGIN)" 'cd $(WORKSPACE) && tail -f $(CORE_BUILD_LOG)'

core.check.log:
	ssh "$(BUILDMCLOGIN)" 'cd $(WORKSPACE) && tail -f $(CORE_CHECK_LOG)'

online.log:
	ssh "$(BUILDMCLOGIN)" 'cd $(WORKSPACE) && tail -f $(ONLINE_BUILD_LOG)'

online.check.log:
	ssh "$(BUILDMCLOGIN)" 'cd $(WORKSPACE) && tail -f $(ONLINE_CHECK_LOG)'

status:
	ssh "$(BUILDMCLOGIN)" 'TZ=Asia/Kolkata uptime'
	ssh "$(BUILDMCLOGIN)" 'cd $(WORKSPACE) && ./printBuildInfo.sh'
	ssh "$(BUILDMCLOGIN)" 'cd $(WORKSPACE) && tail $(BUILDALL_LOG)'
	tail -28 $(WORKSPACE)/getbuilds.log
