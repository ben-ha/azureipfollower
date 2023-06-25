FROM mcr.microsoft.com/azure-cli

RUN mkdir /app
WORKDIR /app

COPY ./azureipfollower.sh .
CMD [ "sh", "azureipfollower.sh" ]