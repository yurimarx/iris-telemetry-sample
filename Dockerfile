ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

COPY ./merge.cpf /tmp/merge.cpf

ENV ISC_CPF_MERGE_FILE=/tmp/merge.cpf

WORKDIR /home/irisowner/dev

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    iris stop IRIS quietly
