Class dc.Sample.PersonREST Extends Sample.REST.Base
{

Parameter Version = "1.0.6";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Get all records of Person class -->
<Route Url="/persons/all" Method="GET" Call="GetAllPersons"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />
<!-- GET method to return JSON for a given person id-->
<Route Url="/persons/:id" Method="GET" Call="GetPerson"/>
<!-- Update a person with id-->
<Route Url="/persons/:id" Method="PUT" Call="UpdatePerson"/>
<!-- Delete a person with id-->
<Route Url="/persons/:id" Method="DELETE" Call="DeletePerson"/>
<!-- Create a person-->
<Route Url="/persons/" Method="POST" Call="CreatePerson"/>
<!-- Create random persons-->
<Route Url="/persons/gen/:amount" Method="POST" Call="CreateRandomPersons"/>


</Routes>
}

/// PersonsREST general information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET info = {
    "version": (version)
  }
  RETURN ..%ProcessResult($$$OK, info)
}

/// Retreive all the records of dc.Sample.Person
ClassMethod GetAllPersons() As %Status
{

    #dim tSC As %Status = $$$OK

    do ##class(dc.Sample.REST.TelemetryUtil).SetTracerProvider("Get.All.Persons", "1.0")
    set tracerProv = ##class(dc.Sample.REST.TelemetryUtil).GetTracerProvider()
    set tracer = tracerProv.GetTracer("Get.All.Persons", "1.0")

    set rootAttr("GetAllPersons") = 1
    set rootSpan = tracer.StartSpan("GetAllPersons", , "Server", .rootAttr)
    set rootScope = tracer.SetActiveSpan(rootSpan)

    set childSpan1 = tracer.StartSpan("Query.All.Persons")
    set child1Scope = tracer.SetActiveSpan(childSpan1)
    Set rset = ##class(dc.Sample.Person).ExtentFunc()
    do childSpan1.SetStatus("Ok")
    do childSpan1.End()
    kill childSpan1


    Set %response.ContentType = ..#CONTENTTYPEJSON
    Write "["
    if rset.%Next() {
        set childSpan2 = tracer.StartSpan("Get.PersonByID")
        set child2Scope = tracer.SetActiveSpan(childSpan2)
        Set person = ##class(dc.Sample.Person).%OpenId(rset.ID)
        
        if person.DOB '= ""  {
            Set person.Age = person.CalculateAge(person.DOB)
            Set person.ZodiacSign = person.CalculateZodiacSign(person.DOB)
        }   
        Do person.%JSONExport()
        do childSpan2.SetStatus("Ok")
        do childSpan2.End()
        kill childSpan2

    }
    While rset.%Next() {   
        Write ","
        set childSpan2 = tracer.StartSpan("Get.PersonByID")
        set child2Scope = tracer.SetActiveSpan(childSpan2)
        Set person = ##class(dc.Sample.Person).%OpenId(rset.ID)
        if person.DOB '= ""  {
            Set person.Age = person.CalculateAge(person.DOB)
            Set person.ZodiacSign = person.CalculateZodiacSign(person.DOB)
        }    
        Do person.%JSONExport()
        do childSpan2.SetStatus("Ok")
        do childSpan2.End()
        kill childSpan2

    }
    Write "]"
    
    do rootSpan.SetStatus("Ok")
    do rootSpan.End()
    kill rootScope

    Quit tSC
}

/// Return one record fo dc.Sample.Person
ClassMethod GetPerson(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException


    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Set person = ##class(dc.Sample.Person).%OpenId(id)

    If '$IsObject(person) Quit ..Http404()

    Do person.%JSONExport()

    Quit tSC
}

/// Creates a new dc.Sample.Person record
ClassMethod CreatePerson() As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set person = ##class(dc.Sample.Person).%New()
    Set data=%request.Content


    $$$TOE(tSC,person.%JSONImport(data))
    $$$TOE(tSC,person.%Save())

    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    //d data.%ToJSON()
    Do person.%JSONExport()

    Quit tSC
}

/// Update a record in dc.Sample.Person with id
ClassMethod UpdatePerson(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set person = ##class(dc.Sample.Person).%OpenId(id)
    If '$IsObject(person) Return ..Http404()
    Set data=%request.Content

    $$$TOE(tSC,person.%JSONImport(data))
    $$$TOE(tSC,person.%Save())

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Do person.%JSONExport()

    Quit tSC
}

/// Delete a record with id in dc.Sample.Person
ClassMethod DeletePerson(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set person = ##class(dc.Sample.Person).%OpenId(id)
    If '$IsObject(person) Return ..Http404()

    $$$TOE(tSC,person.%DeleteId(id))

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON

    Quit tSC
}

ClassMethod CreateRandomPersons(amount As %Integer) As %Status
{
#dim tSC As %Status = $$$OK
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Try {
        set status = ##class(dc.Sample.Person).AddTestData(amount)
        $$$ThrowOnError(status)
        Set message = "Created "_amount_" random persons in Sample.Person data"
    } Catch(ex) {
        Set tSC = ex.Code
    }
    Return tSC
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/crud"
  Set swagger.info.title = "InterSystems IRIS REST CRUD demo"
  Set swagger.info.version = "0.1"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

}
