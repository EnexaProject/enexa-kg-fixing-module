FROM adoptopenjdk/openjdk8
ADD reason-explain-1.0-SNAPSHOT-jar-with-dependencies.jar NCSR-Module.jar
ADD ./run_fixing .
ENV PATH="${PATH}:/usr/local/bin"

COPY --from=enexa-utils:1 / /.
CMD ./run_fixing
