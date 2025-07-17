Class dc.Sample.Person Extends (%Persistent, %JSON.Adaptor, %Populate)
{

Property Name As %VarString;

Property Title As %String;

Property Company As %String;

Property Phone As %VarString;

Property ZodiacSign As %String;

Property DOB As %Date(MAXVAL = "$piece($horolog, "","", 1)");

Property Age As %Integer;

/// Index for property DOB
Index DOBIndex On DOB;

ClassMethod AddTestData(amount As %Integer = 10)
{
    d ..Populate(amount)
}

/// This method calculates the age of a person based on their birth date.
/// pDOB: Date of Birth in $HOROLOG format (e.g., "66406,0" for 2025-07-16)
/// Returns: The age in years as an integer.
ClassMethod CalculateAge(pDOB As %Date) As %Integer
{
    set tracerProv = ##class(dc.Sample.REST.TelemetryUtil).GetTracerProvider()
    set tracer = tracerProv.GetTracer("Get.All.Persons", "1.0")
    set childSpan1 = tracer.StartSpan("CalculateAge")
    set child1Scope = tracer.SetActiveSpan(childSpan1)
    // Get today's date in $HOROLOG format
    Set today = +$H

    // Extract year, month, and day from today's date
    Set todayYear = $PIECE($ZDATE(today,3),"-",1)
    Set todayMonth = $PIECE($ZDATE(today,3),"-",2)
    Set todayDay = $PIECE($ZDATE(today,3),"-",3)

    // Extract year, month, and day from the birth date
    Set dobYear = $PIECE($ZDATE(pDOB,3),"-",1)
    Set dobMonth = $PIECE($ZDATE(pDOB,3),"-",2)
    Set dobDay = $PIECE($ZDATE(pDOB,3),"-",3)

    // Calculate initial age
    Set age = todayYear - dobYear

    // Adjust age if birthday hasn't occurred yet this year
    If (todayMonth < dobMonth) || ((todayMonth = dobMonth) && (todayDay < dobDay)) {
        Set age = age - 1
    }

    if age '= "" {
        set eventAttr("Age"_age) = age
    } Else {
        set eventAttr("No Age") = "No age"
    }
    do childSpan1.AddEvent("Age", .eventAttr)

    do childSpan1.SetStatus("Ok")
    do childSpan1.End()
    kill childSpan1


    Quit age
}

/// Takes a date of birth and returns the corresponding zodiac sign.
ClassMethod CalculateZodiacSign(pDate As %Date) As %String
{
    // Define the start and end dates for each zodiac sign (month, day)
    // Note: ObjectScript dates are stored as integer days since 1840-12-31
    // We'll extract month and day for comparison.

    // Using a series of if/else if statements for clarity.
    // Order matters here, generally starting from January or a logical flow.

    // Extract month and day from the input date
    // %DATEFN(date, flag) can be used, or direct methods on %Date object.
    // For simplicity, we'll convert to a display format and extract.
    // A more robust way might involve calculating the day of year or comparing actual date ranges.

    // Let's use %DATEFN for simplicity to get month and day numbers.
    // %DATEFN(date, 3) returns month number, %DATEFN(date, 4) returns day number.

    set tracerProv = ##class(dc.Sample.REST.TelemetryUtil).GetTracerProvider()
    set tracer = tracerProv.GetTracer("Get.All.Persons", "1.0")
    set childSpan1 = tracer.StartSpan("GetZodiacSign")
    set child1Scope = tracer.SetActiveSpan(childSpan1)
    
    Set sign = ""

    Set tMonth = $SYSTEM.SQL.DATEPART("month", pDate)
    Set tDay = $SYSTEM.SQL.DATEPART("day", pDate)

    do childSpan1.AddEvent("ZodiacSign", .eventAttr)
    
    If (tMonth = 3) && (tDay >= 21) {
        Set sign = "Aries ♈" // March 21 - April 19
    } ElseIf (tMonth = 4) && (tDay <= 19) {
        Set sign = "Aries ♈" // March 21 - April 19
    } ElseIf (tMonth = 4) && (tDay >= 20) {
        Set sign = "Taurus ♉" // April 20 - May 20
    } ElseIf (tMonth = 5) && (tDay <= 20) {
        Set sign = "Taurus ♉" // April 20 - May 20
    } ElseIf (tMonth = 5) && (tDay >= 21) {
        Set sign = "Gemini ♊" // May 21 - June 20
    } ElseIf (tMonth = 6) && (tDay <= 20) {
        Set sign = "Gemini ♊" // May 21 - June 20
    } ElseIf (tMonth = 6) && (tDay >= 21) {
        Set sign = "Cancer ♋" // June 21 - July 22
    } ElseIf (tMonth = 7) && (tDay <= 22) {
        Set sign = "Cancer ♋" // June 21 - July 22
    } ElseIf (tMonth = 7) && (tDay >= 23) {
        Set sign = "Leo ♌" // July 23 - August 22
    } ElseIf (tMonth = 8) && (tDay <= 22) {
        Set sign = "Leo ♌" // July 23 - August 22
    } ElseIf (tMonth = 8) && (tDay >= 23) {
        Set sign = "Virgo ♍" // August 23 - September 22
    } ElseIf (tMonth = 9) && (tDay <= 22) {
        Set sign = "Virgo ♍" // August 23 - September 22
    } ElseIf (tMonth = 9) && (tDay >= 23) {
        Set sign = "Libra ♎" // September 23 - October 22
    } ElseIf (tMonth = 10) && (tDay <= 22) {
        Set sign = "Libra ♎" // September 23 - October 22
    } ElseIf (tMonth = 10) && (tDay >= 23) {
        Set sign = "Scorpio ♏" // October 23 - November 21
    } ElseIf (tMonth = 11) && (tDay <= 21) {
        Set sign = "Scorpio ♏" // October 23 - November 21
    } ElseIf (tMonth = 11) && (tDay >= 22) {
        Set sign = "Sagittarius ♐" // November 22 - December 21
    } ElseIf (tMonth = 12) && (tDay <= 21) {
        Set sign = "Sagittarius ♐" // November 22 - December 21
    } ElseIf (tMonth = 12) && (tDay >= 22) {
        Set sign = "Capricorn ♑" // December 22 - January 19
    } ElseIf (tMonth = 1) && (tDay <= 19) {
        Set sign = "Capricorn ♑" // December 22 - January 19
    } ElseIf (tMonth = 1) && (tDay >= 20) {
        Set sign = "Aquarius ♒" // January 20 - February 18
    } ElseIf (tMonth = 2) && (tDay <= 18) {
        Set sign = "Aquarius ♒" // January 20 - February 18
    } ElseIf (tMonth = 2) && (tDay >= 19) {
        Set sign = "Pisces ♓" // February 19 - March 20
    } ElseIf (tMonth = 3) && (tDay <= 20) {
        Set sign = "Pisces ♓" // February 19 - March 20
    } Else {
        Set sign = "Invalid date"
    }
    
    do childSpan1.SetStatus("Ok")
    do childSpan1.End()
    kill childSpan1

    Quit sign
}

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Title</Value>
</Value>
<Value name="4">
<Value>Company</Value>
</Value>
<Value name="5">
<Value>Phone</Value>
</Value>
<Value name="6">
<Value>DOB</Value>
</Value>
<Value name="7">
<Value>Age</Value>
</Value>
<Value name="8">
<Value>ZodiacSign</Value>
</Value>
</Data>
<DataLocation>^Sample.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^Sample.PersonD</IdLocation>
<IndexLocation>^Sample.PersonI</IndexLocation>
<StreamLocation>^Sample.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
