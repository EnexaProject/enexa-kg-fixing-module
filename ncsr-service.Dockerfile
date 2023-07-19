FROM adoptopenjdk/openjdk8
ADD reason-explain-1.0-SNAPSHOT-jar-with-dependencies.jar NCSR-Module.jar
ADD ./run_fixing .
ENV PATH="${PATH}:/usr/local/bin"
#ADD ./enexa-parameter .
#ADD ./enexa-add-file .
#ADD ./sparql-update .
#
#RUN chmod +x enexa-parameter
#RUN chmod +x enexa-add-file
#RUN chmod +x sparql-update

COPY --from=enexa-utils:1 / /.
CMD ./run_fixing
