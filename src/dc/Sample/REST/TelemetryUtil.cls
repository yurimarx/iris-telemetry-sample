Class dc.Sample.REST.TelemetryUtil Extends %RegisteredObject
{

/// Set tracer provider
ClassMethod SetTracerProvider(ServiceName As %String, Version As %String) As %Status
{
    Set sc = $$$OK
    set attributes("service.name") = ServiceName
    set attributes("service.version") = Version
    Set tracerProv = ##class(%Trace.TracerProvider).%New(.attributes)
    Set sc = ##class(%Trace.Provider).SetTracerProvider(tracerProv)
    Quit sc
}

/// Get tracer provider
ClassMethod GetTracerProvider() As %Trace.Provider
{
    Return ##class(%Trace.Provider).GetTracerProvider()
}

}
