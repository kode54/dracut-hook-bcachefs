PREFIX = /usr
DESTDIR =

RULES_SRC = 80-bcachefs.rules
SCRIPT_SRC = bcachefs_finished.sh module-setup.sh

INSTALL = install
SHFMT = shfmt
SHELLCHECK = shellcheck

.PHONY: install
install:
	$(INSTALL) -Dm644 -t $(DESTDIR)/$(PREFIX)/lib/dracut/modules.d/90bcachefs $(RULES_SRC)
	$(INSTALL) -Dm755 -t $(DESTDIR)/$(PREFIX)/lib/dracut/modules.d/90bcachefs $(SCRIPT_SRC)

.PHONY: check
check:
	$(SHFMT) -i 4 -l -d $(SCRIPT_SRC)
	$(SHELLCHECK) -S style $(SCRIPT_SRC)