Please, clone, build, and execute https://github.com/EnexaProject/enexa-utils locally.

Then, run:
```bash 
sudo docker build --no-cache -t enexa-ncsr-service:latest -f ./Dockerfile .
```

and to test:

```bash
sudo docker run --rm \                                                                  
    -v "$(PWD)/test-shared-dir:/shared" \
    -e ENEXA_SHARED_DIRECTORY=/shared \
    -e ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test \
    -e ENEXA_SERVICE_URL=http://enexa:36321/ \
    -e ENEXA_WRITEABLE_DIRECTORY=/shared \
    -e ENEXA_MODULE_INSTANCE_IRI=http://example.org/moduleinstance-19-07 \
    --network enexa-utils_default \
    enexa-ncsr-service:latest
```

The documentation is available [here](https://enexa.eu/documentation). You can find the module documentation [here](https://enexa.eu/documentation/modules_overview.html#kg-fixing-module).
