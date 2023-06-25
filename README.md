# azureipfollower
Allow access to Azure machines only from your dynamic IP, automatically.

# Objective
Provide a simple way to restrict access to Azure machines (for example from your home connection), without deploying complex solutions.

# Configuration

| Environment variable | Details | Requirement | Example |
|----------------------|---------|-------------|---------|
| NSG_AND_RESOURCE | Pairs of NSG and resource groups to apply the rule on separated by a space | Required | <pre>NSG1:MYGROUP1 NSG2:MYGROUP2</pre>
| SLEEP_TIME | Time to wait between update iterations in seconds. The default is 5 minutes | Optional | <pre>SLEEP_TIME=500</pre>

# One time setup
1. Run `setup.sh` and follow the instructions to generate a service principal for the docker container.
2. Save the .env file which contains all the needed login information

# Deploy
1. Pull the [container](https://hub.docker.com/r/benhh1/azureipfollower)
   1. ```docker pull benhh1/azureipfollower```
2. Configure the container to run with the environment variables from the .env file and from the configuration section.

Enjoy!
