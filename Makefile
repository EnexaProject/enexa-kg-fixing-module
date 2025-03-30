IMAGE=hub.cs.upb.de/enexa/images/enexa-kg-fixing-module
VERSION=1.0.0
TAG=$(IMAGE):$(VERSION)
TEST_DIR=test-shared-dir

build:
	docker build -t $(TAG) .

test:
	docker run --rm \
	-v $(PWD)/test-shared-dir:/shared \
	-e ENEXA_EXPERIMENT_IRI=http://example.org/experiment1 \
	-e ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test \
	-e ENEXA_META_DATA_GRAPH=http://example.org/meta-data \
	-e ENEXA_MODULE_INSTANCE_DIRECTORY=/shared/experiment1/module1 \
	-e ENEXA_MODULE_INSTANCE_IRI=http://example.org/moduleinstance-$$(date +%s) \
	-e ENEXA_SERVICE_URL=http://enexa:36321/ \
	-e ENEXA_SHARED_DIRECTORY=/shared \
	-e ENEXA_WRITEABLE_DIRECTORY=/shared/experiment1 \
	-e TEST_RUN=true \
	--network enexa-utils_default \
	$(TAG)

test-with-local-image:
	docker run --rm \
	-v $(PWD)/test-shared-dir:/shared \
	-e ENEXA_EXPERIMENT_IRI=http://example.org/experiment1 \
	-e ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test \
	-e ENEXA_META_DATA_GRAPH=http://example.org/meta-data \
	-e ENEXA_MODULE_INSTANCE_DIRECTORY=/shared/experiment1/module1 \
	-e ENEXA_MODULE_INSTANCE_IRI=http://example.org/moduleinstance-$$(date +%s) \
	-e ENEXA_SERVICE_URL=http://enexa:36321/ \
	-e ENEXA_SHARED_DIRECTORY=/shared \
	-e ENEXA_WRITEABLE_DIRECTORY=/shared/experiment1 \
	-e TEST_RUN=true \
	-p 9080:9080 \
	--network enexa-utils_default \
	enexa-ncsr-service:latest

push:
	docker push $(TAG)

push-latest:
	docker tag $(TAG) $(IMAGE):latest
	docker push $(IMAGE):latest

update-ttl-file:
	echo "# Don't change this file! It is generated based on module.ttl.template." > module.ttl
	sed 's/$$(VERSION)/$(VERSION)/g' module.ttl.template | sed 's=$$(TAG)=$(TAG)=g' >> module.ttl


