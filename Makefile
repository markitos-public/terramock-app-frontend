.PHONY: image run delete help default publish

default: help

help:
	chmod +x ./bin/make-help.sh
	./bin/make-help.sh
image:
	chmod +x ./bin/make-image.sh
	./bin/make-image.sh $(image)
run:
	chmod +x ./bin/make-run.sh
	./bin/make-run.sh $(version)

delete:
	chmod +x ./bin/make-delete.sh
	./bin/make-delete.sh $(version)

publish:
	chmod +x ./bin/make-publish.sh
	./bin/make-publish.sh $(image) $(project_id)
