FROM amazoncorretto:21

ADD reason-explain-1.0-SNAPSHOT.jar NCSR-Module.jar
ADD lib lib
ADD ./run_fixing .
RUN chmod +x ./run_fixing
ADD native_libs native_libs
ADD tentris_v0.17.1_x86-64-v3 tentris
RUN chmod +x ./tentris/tentris
ENV PATH="${PATH}:/usr/local/bin"

EXPOSE 9080

COPY --from=hub.cs.upb.de/enexa/images/enexa-utils:1 / /.
CMD ./run_fixing
