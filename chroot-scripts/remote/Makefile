SHELL := /bin/bash

ENVFILE = ../envvars.sh

include $(ENVFILE)

MYRANDNUMBER = $(shell od -vAn -N2 -tu2 < /dev/urandom | tr -d ' ')
BUILD_IS_RUNNING = $(shell ssh dennis@buildmc "pgrep make" > /dev/null && echo yes || echo no)
LOCAL_BUILD_IS_RUNNING = $(shell pgrep vim > /dev/null && echo yes || echo no)

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

buildsession:
	@ssh dennis@buildmc "schroot -l --all-sessions" | grep $(BUILD_SESSION_NAME) > /dev/null || \
		{ echo "Starting build session"; ssh dennis@buildmc "schroot -c $(CHRNAME) -b -n $(BUILD_SESSION_NAME)"; }

nobuilds-running-local:
	@[ "$(LOCAL_BUILD_IS_RUNNING)" == "yes" ] && echo "WARNING: Build is running!" || echo "No builds running"

nobuilds-running:
	@[ "$(BUILD_IS_RUNNING)" == "no" ] && echo "No builds running" || { echo "ERROR: Build is running!"; false; }

warn-builds-running:
	@[ "$(BUILD_IS_RUNNING)" == "yes" ] && echo "WARNING: Build is running!" || echo "No builds running"

buildmc-init: setup-buildmc update-packages init

getbuilds: build-tarballs build2store download extract-local

init: init-core init-online

update-packages: stop
	ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(UHOME) -- bash -c 'sudo apt-get update && sudo apt-get full-upgrade -y && sudo apt-get install -y xvfb chromium-browser'"

init-core: stop
	ssh dennis@buildmc 'cd $(WORKSPACE) && git clone --depth 10 --single-branch --branch $(CORE_BRANCH) $(COREURL) $(REPODIR)' && \
		ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(WORKSPACE) -- bash -c 'tar -xf $(CORE_EXTERNALS_TARBALL_FNAME)'" && \
		rsync -vrt --size-only --existing --exclude '.git' $(COREDIR)/ dennis@buildmc:$(COREDIR)/ && \
		ssh dennis@buildmc "cd $(WORKSPACE) && mkdir -p bkup && mv $(CORE_EXTERNALS_TARBALL_FNAME) bkup/"

init-online: stop
	ssh dennis@buildmc 'cd $(WORKSPACE) && git clone --depth 10 --single-branch --branch $(ONLINE_BRANCH) $(ONLINEURL) $(ONLINEREPODIR)'

clean: clean-core clean-online

clean-core: stop
	ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(COREDIR) -- bash -c 'make clean'"

clean-online: stop
	ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'make clean'"

stop: buildsession
	-ssh dennis@buildmc "schroot -c $(BUILD_SESSION) -r -d $(WORKSPACE) -- bash -c 'pkill make; pkill clang'"

autogen.input: $(COREDIR)/autogen.input nobuilds-running
	cat $(COREDIR)/autogen.input | sed -e 's/--with-parallelism=.*/--with-parallelism=$(NPARALLEL)/' | \
		ssh dennis@buildmc "cat > $(COREDIR)/autogen.input"

core: buildsession autogen.input nobuilds-running
	@echo "Starting build in $(COREDIR)"
	ssh dennis@buildmc \
		"schroot -c $(BUILD_SESSION) -r -d $(COREDIR) -- bash -c '(./autogen.sh && make build-nocheck) >> $(CORE_BUILD_LOG) 2>&1 &'"

core.incbuild: buildsession nobuilds-running
	@echo "Starting incremental build in $(COREDIR)"
	ssh dennis@buildmc \
		"schroot -c $(BUILD_SESSION) -r -d $(COREDIR) -- bash -c 'make build-nocheck >> $(CORE_BUILD_LOG) 2>&1 &'"

online: buildsession nobuilds-running setupnpm
	@echo "Starting build in $(ONLINEDIR)"
	ssh dennis@buildmc \
		"schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'source ~/.nvm/nvm.sh && (./autogen.sh && $(ONLINE_CONFIG_CMD) && make -j$(NPARALLEL)) >> $(ONLINE_BUILD_LOG) 2>&1 &'"

online.incbuild: buildsession nobuilds-running
	@echo "Starting incremental build in $(ONLINEDIR)"
	ssh dennis@buildmc \
		"schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'source ~/.nvm/nvm.sh && make -j$(NPARALLEL) >> $(ONLINE_BUILD_LOG) 2>&1 &'"

setupnpm:
	@echo "Setting up nvm"
	ssh dennis@buildmc "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | NODE_VERSION=v13.6.0 bash"

core.check: buildsession nobuilds-running
	ssh dennis@buildmc \
		"schroot -c $(BUILD_SESSION) -r -d $(COREDIR) -- bash -c 'make $(CORE_MAKECHECK_TARGETS) >> $(CORE_CHECK_LOG) 2>&1 &'"
	@echo "Started core checks"

online.check: buildsession nobuilds-running
	ssh dennis@buildmc \
		"schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'source ~/.nvm/nvm.sh && make $(ONLINE_MAKECHECK_TARGETS) >> $(ONLINE_CHECK_LOG) 2>&1 &'"
	@echo "Started online checks (including cypress)"

online.unitcheck: buildsession nobuilds-running
	ssh dennis@buildmc \
		"schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'source ~/.nvm/nvm.sh && cd test && make $(ONLINE_MAKECHECK_TARGETS) >> $(ONLINE_CHECK_LOG) 2>&1 &'"
	@echo "Started online unit checks (cypress excluded)"

online.cypress-check: buildsession nobuilds-running
	ssh dennis@buildmc \
		"schroot -c $(BUILD_SESSION) -r -d $(ONLINEDIR) -- bash -c 'source ~/.nvm/nvm.sh && cd cypress_test && make check >> $(ONLINE_CHECK_LOG) 2>&1 &'"
	@echo "Started online cypress checks"

core.git.pull:
	ssh dennis@buildmc "cd $(COREDIR) && git pull -r origin $(CORE_BRANCH)"

online.git.pull:
	ssh dennis@buildmc "cd $(ONLINEDIR) && git pull -r origin $(ONLINE_BRANCH)"

core.log:
	ssh dennis@buildmc "tail -f $(CORE_BUILD_LOG)"

core.check.log:
	ssh dennis@buildmc "tail -f $(CORE_CHECK_LOG)"

online.log:
	ssh dennis@buildmc "tail -f $(ONLINE_BUILD_LOG)"

online.check.log:
	ssh dennis@buildmc "tail -f $(ONLINE_CHECK_LOG)"

status:
	ssh dennis@buildmc "uptime"
	ssh dennis@buildmc "cd $(LODEVSCRIPTS_DIR) && bash ./printBuildInfo.sh"

build-tarballs:
	@[ ! -z "$(CORE_BASE_COMMIT)" ] && true || { echo "CORE_BASE_COMMIT variable not set!" && false; }
	@[ ! -z "$(ONLINE_BASE_COMMIT)" ] && true || { echo "ONLINE_BASE_COMMIT variable not set!" && false; }
	@echo "Generating core build tarballs..."
	ssh dennis@buildmc "cd $(LODEVSCRIPTS_DIR) && bash ./genCoreTarballs.sh $(CORE_BASE_COMMIT)"
	@echo "Generating online build tarballs..."
	ssh dennis@buildmc "cd $(LODEVSCRIPTS_DIR) && bash ./genOnlineTarballs.sh $(ONLINE_BASE_COMMIT)"
	@echo "Gzipping log files..."
	ssh dennis@buildmc "cd $(WORKSPACE) && gzip -f *.log"
	@echo "creating checksum file..."
	ssh dennis@buildmc "cd $(WORKSPACE) && sha256sum *.gz > $(CSUMSFILE)"
	@echo "---List of files in $(WORKSPACE)---------"
	@ssh dennis@buildmc "cd $(WORKSPACE) && TZ=Asia/Kolkata ls -lhta"
	@echo "-----------------------------------------"
	@echo "Finished. Run 'make build2store' to copy all build tarballs to storemc"

list:
	@echo "---List of files in $(WORKSPACE)---------"
	@ssh dennis@buildmc "cd $(WORKSPACE) && TZ=Asia/Kolkata ls -lhta"
	@echo "-----------------------------------------"

build2store: warn-builds-running
	@echo "Copying build tarballs from buildmc:$(WORKSPACE) to storemc:$(STOREMC_BUILDTARBALLS_DIR)"
	ssh root@storemc "mkdir -p $(STOREMC_BUILDTARBALLS_DIR)"
	ssh dennis@buildmc "cd $(WORKSPACE) && scp $(SSH_NOHOSTCHECK_FLAGS) *.gz $(CSUMSFILE) root@storemc:$(STOREMC_BUILDTARBALLS_DIR)/"
	ssh root@storemc "cd $(STOREMC_BUILDTARBALLS_DIR) && sha256sum -c $(CSUMSFILE)"
	@echo "Copy successful (checksums passed)"

download:
	scp root@storemc:$(STOREMC_BUILDTARBALLS_DIR)/*.gz $(WORKSPACE)/
	scp root@storemc:$(STOREMC_BUILDTARBALLS_DIR)/$(CSUMSFILE) $(WORKSPACE)/
	cd $(WORKSPACE) && sha256sum -c $(CSUMSFILE)
	@echo "Finished downloading from storemc (checksums PASSED)"

download-direct: warn-builds-running
	scp dennis@buildmc:$(WORKSPACE)/*.gz $(WORKSPACE)/
	scp dennis@buildmc:$(WORKSPACE)/$(CSUMSFILE) $(WORKSPACE)/
	cd $(WORKSPACE) && sha256sum -c $(CSUMSFILE)
	@echo "Finished downloading to local machine (direct) (checksums PASSED)"

extract-local: extract-local-core extract-local-online

extract-local-core: $(CORE_BUILD_TARBALL) $(CORE_CHANGEDFILES_TARBALL)
	@echo "Extracting $(CORE_BUILD_TARBALL) and $(CORE_CHANGEDFILES_TARBALL) ..."
	cd $(WORKSPACE) && tar -xf $(CORE_BUILD_TARBALL) && tar -xf $(CORE_CHANGEDFILES_TARBALL)
	@echo "Done extracting for core"

extract-local-online: $(ONLINE_BUILD_TARBALL) $(ONLINE_CHANGEDFILES_TARBALL)
	@echo "Extracting $(ONLINE_BUILD_TARBALL) and $(ONLINE_CHANGEDFILES_TARBALL) ..."
	cd $(WORKSPACE) && tar -xf $(ONLINE_BUILD_TARBALL) && tar -xf $(ONLINE_CHANGEDFILES_TARBALL)
	@echo "Done extracting for online"

upload:
	@echo "This is not needed anymore. Run 'make storemc-init' instead."
	#bash ./upload_to_store.sh

setup-buildmc:
	bash ./setup_build_machine.sh

storemc-init:
	bash ./setup_store_machine.sh

list-storemc:
	ssh root@storemc "ls -lht /root/ && ls -lht /media/extra/build"

