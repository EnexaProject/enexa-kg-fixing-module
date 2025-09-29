Please, clone, build, and execute https://github.com/EnexaProject/enexa-utils locally.

Then, run:
```bash 
sudo docker build --no-cache -t enexa-ncsr-service:latest -f ./Dockerfile .
```

and to test:

```bash
make test-with-local-image
```

The documentation is available [here](https://enexa.eu/documentation). You can find the module documentation [here](https://enexa.eu/documentation/modules_overview.html#kg-fixing-module).
