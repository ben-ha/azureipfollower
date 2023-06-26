FROM python:alpine

RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo make curl
RUN pip install --upgrade pip
RUN pip install azure-cli

RUN mkdir /app
WORKDIR /app

COPY ./azureipfollower.sh .
CMD [ "sh", "azureipfollower.sh" ]