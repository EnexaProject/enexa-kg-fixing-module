#!/bin/sh

PREFIX=http://w3id.org/dice-research/enexa/module/kg-fixing/

# If this is a test run
if [ "${TEST_RUN:-false}" = true ]
then  
  # things which ENEXA is supposed to do
  mkdir -p $ENEXA_WRITEABLE_DIRECTORY
  echo "INSERT DATA { GRAPH <$ENEXA_META_DATA_GRAPH> { <$ENEXA_MODULE_INSTANCE_IRI> <${PREFIX}parameter/t-boxFile> <http://ncsr.gr/t-box-filename> . <http://ncsr.gr/t-box-filename> <http://w3id.org/dice-research/enexa/ontology#location> 'enexa-dir://dbpedia_merged.ttl' }}" \
    |sparql-update "$ENEXA_META_DATA_ENDPOINT"
  echo "INSERT DATA { GRAPH <$ENEXA_META_DATA_GRAPH> { <$ENEXA_MODULE_INSTANCE_IRI> <${PREFIX}parameter/a-boxFile> <http://ncsr.gr/a-box-filename> . <http://ncsr.gr/a-box-filename> <http://w3id.org/dice-research/enexa/ontology#location> 'enexa-dir://dbpediatop100.nt' }}" \
    |sparql-update "$ENEXA_META_DATA_ENDPOINT"
fi

mkdir -p /tmp/output

# java -Xmx220g -XX:-UseGCOverheadLimit -jar NCSR-Module.jar \
#     -t "$(enexa-parameter "${PREFIX}parameter/t-boxFile")" \
#     -a "$(enexa-parameter "${PREFIX}parameter/a-boxFile")" \
#     -o /tmp/output/fixed.ttl \
#     -c

echo "Loading ABox into the graph"
echo ""

./tentris/tentris load --into-graph "http://enexa.eu/kg-fixing-module" < "$(enexa-parameter "${PREFIX}parameter/a-boxFile")"

echo ""

sleep 2

echo "Serving Tentris"
echo ""

./tentris/tentris serve > tentris_serve_output.log 2>&1 &

echo ""

sleep 2

echo "Testing Tentris SPARQL Endpoint by making a count query"
echo ""

curl -G --data-urlencode 'query=SELECT (COUNT(*) AS ?C) FROM <http://enexa.eu/kg-fixing-module>  WHERE { ?s ?p ?o . }' 'http://localhost:9080/sparql'

echo ""

sleep 2

echo "Java Version"
echo ""

java --version

sleep 2

echo "Starting java process"
echo ""

java -Xmx220g -XX:-UseGCOverheadLimit \
    -Djava.library.path=./native_libs \
    -jar NCSR-Module.jar \
    -t "$(enexa-parameter "${PREFIX}parameter/t-boxFile")" \
    -a "http://localhost:9080" \
    -o /tmp/output/fixed.ttl \
    -sk \
    -e \
    -pi \
    -x \
    -fixS 4 \
    -depth 1 \
    -reasoner 1 \
    -graph http://enexa.eu/kg-fixing-module

# --add-exports=java.xml/com.sun.org.apache.xml.internal.serialize=ALL-UNNAMED \

enexa-add-file /tmp/output/fixed.ttl "${PREFIX}result/fixedKG"
