.PHONY: image run delete help default publish

default: help

help:
	chmod +x ./bin/make-help.sh
	./bin/make-help.sh

image:
	@if ! echo "$(version)" | grep -Eq '^(local|google)=[0-9]+\.[0-9]+\.[0-9]+$$'; then \
	  echo '❌ ERROR: Debes pasar version="local=n.n.n" o version="google=n.n.n" (semver)'; \
	  exit 2; \
	fi
	chmod +x ./bin/make-image.sh
	./bin/make-image.sh $(version)

run:
	@if ! echo "$(version)" | grep -Eq '^(local|google)=[0-9]+\.[0-9]+\.[0-9]+$$'; then \
	  echo '❌ ERROR: Debes pasar version="local=n.n.n" o version="google=n.n.n" (semver)'; \
	  exit 2; \
	fi
	chmod +x ./bin/make-run.sh
	./bin/make-run.sh $(version)


delete:
	@if ! echo "$(version)" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$$'; then \
	  echo '❌ ERROR: Debes pasar n.n.n (semver)'; \
	  exit 2; \
	fi
	chmod +x ./bin/make-delete.sh
	./bin/make-delete.sh $(version)

tag:
	@if ! echo "$(version)" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$$'; then \
	  echo '❌ ERROR: Debes pasar n.n.n (semver)'; \
	  exit 2; \
	fi
	chmod +x ./bin/make-tag.sh
	./bin/make-tag.sh $(version)

delete-tag:
	@if ! echo "$(version)" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$$'; then \
	  echo '❌ ERROR: Debes pasar n.n.n (semver)'; \
	  exit 2; \
	fi
	chmod +x ./bin/make-delete-tag.sh
	./bin/make-delete-tag.sh $(version)

publish:
	@if ! echo "$(version)" | grep -Eq '^version=[0-9]+\.[0-9]+\.[0-9]+$$'; then \
	  echo '❌ ERROR: Debes pasar version="version=n.n.n" (semver)'; \
	  exit 2; \
	fi
	chmod +x ./bin/make-publish.sh
	./bin/make-publish.sh $(version) $(project_id)

clean:
	rm -rf .terraform
	rm -f *.tfstate *.tfstate.backup .terraform.lock.hcl