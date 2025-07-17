## iris-telemetry-sample

 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-telemetry-sample)
 
This is a Sample to show IRIS and Jaeger for tracing


## Installation for development

Create your repository from template.

Clone/git pull the repo into any local directory e.g. like it is shown below (here I show all the examples related to this repository, but I assume you have your own derived from the template):

```
$ git clone https://github.com/yurimarx/iris-telemetry-sample.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d --build
```


## How to Work With it

1. Create some fake testing data. To do that open IRIS terminal or web terminal on /localhost:52773/terminal/  and call:

```
USER>do ##class(dc.Sample.Person).AddTestData(10)
```
This will create 10 random records in dc.Sample.Person class.
 
2. Open http://localhost:52773/swagger-ui/index.html and execute the endpoint /persons/all

3. Go to Jaeger on http://localhost:16686/search 

4. Select Get.All.Persons on Service field and click Find Traces

5. Click on the trace found to see the details
