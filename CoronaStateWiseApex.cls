public with sharing class CoronaStateWiseApex {
public CoronaStateWiseApex() {

}

public static HttpResponse getNationalwideSeriesAPI(){
    HttpResponse httpResponse;
    String endPoint='https://api.covid19india.org/data.json';
    try {
        Http http= new Http();
        HttpRequest httpRequest= new HttpRequest();
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setMethod('GET');
        httpRequest.setEndPoint(endPoint);
        httpRequest.setTimeout(1300);
        httpResponse= http.send(httpRequest);
        System.debug('HttpResponse for getNationalWideSeries::::'+httpResponse);
        System.debug('getNationalWideSeries - HttpResponse.getBody::::'+httpResponse.getBody());
    }catch(Exception e){
        System.debug('Exception in getNatiionalWideSeries:::::'+e.getLineNumber()+'~~ message:::'+e.getMessage());
    }
    return httpResponse;
}

public static HttpResponse getStateWiseSeriesAPI(){
    HttpResponse httpResponse;
    String endPoint='https://api.covid19india.org/v2/state_district_wise.json';
    try {
        Http http= new Http();
        HttpRequest httpRequest= new HttpRequest();
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setMethod('GET');
        httpRequest.setEndPoint(endPoint);
        httpRequest.setTimeout(1300);
        httpResponse= http.send(httpRequest);
        System.debug('HttpResponse for getStateWiseSeriesAPI::::'+httpResponse);
        System.debug('getStateWiseSeriesAPI - HttpResponse.getBody::::'+httpResponse.getBody());
    }catch(Exception e){
        System.debug('Exception in getNatiiongetStateWiseSeriesAPIalWideSeries:::::'+e.getLineNumber()+'~~ message:::'+e.getMessage());
    }
    return httpResponse;
}

@AuraEnabled
public static List<StateWrapper> getStateWiseImpacts(){
    List<StateWrapper> stateWrapperList= new List<StateWrapper>();
    List<JSON2ApexStateWiseJsonClass> json2ApexStateWiseJsonClassList;
    try {
        HttpResponse statewiseResponse=CoronaStateWiseApex.getStateWiseSeriesAPI();
        if(statewiseResponse.getStatusCode() == 200){
            json2ApexStateWiseJsonClassList= JSON2ApexStateWiseJsonClass.parse(statewiseResponse.getBody());
            for(JSON2ApexStateWiseJsonClass obj: json2ApexStateWiseJsonClassList){
                if(obj.state=='Tamil Nadu'){
                    for(JSON2ApexStateWiseJsonClass.DistrictData objData: obj.districtData){
                        StateWrapper stateWrapper= new StateWrapper();
                        stateWrapper.confirmed=objData.confirmed;
                        stateWrapper.districtName=objData.district;
                        stateWrapperList.add(stateWrapper);
                    }
                }
            }
        }
        
    }catch(Exception e){
        System.debug('Error in getStateWiseImpacts:::'+e.getLineNumber()+'~~message ::::'+e.getMessage());
    }
    System.debug('stateWrapperList::::'+stateWrapperList);
    System.debug('stateWrapperList Size:::'+stateWrapperList.size());
    return stateWrapperList;
}

@AuraEnabled
public static List<StateWiseDetails> getStateWideDetails(){
    List<StateWiseDetails> stateWiseDetailsList= new List<StateWiseDetails>();
    JSON2ApexNationStateTestCounts json2ApexNationStateTestCountsList;
    try{
        HttpResponse stateWideResponse= CoronaStateWiseApex.getNationalwideSeriesAPI();
        if(stateWideResponse.getStatusCode() == 200){
            json2ApexNationStateTestCountsList=JSON2ApexNationStateTestCounts.parse(stateWideResponse.getBody());
            for(JSON2ApexNationStateTestCounts.Statewise stateWiseObj :json2ApexNationStateTestCountsList.statewise){
                StateWiseDetails obj= new StateWiseDetails();
                obj.active= Integer.valueOf(stateWiseObj.active);
                obj.confirmed=Integer.valueOf(stateWiseObj.confirmed);
                obj.deaths=Integer.valueOf(stateWiseObj.deaths);
                obj.recovered=Integer.valueOf(stateWiseObj.recovered);
                obj.state=stateWiseObj.state;
                stateWiseDetailsList.add(obj);
        }
        }
    }catch(exception e){
        System.debug('Exception in sateWise Details List:::'+e.getMessage()+'~~~~~Line'+e.getLineNumber());
    }
    System.debug('stateWiseDetailsList::::'+stateWiseDetailsList);
    System.debug('stateWiseDetailsList Size:::'+stateWiseDetailsList.size());
    return stateWiseDetailsList;
}

@AuraEnabled
public static List<TestedWrapperDetails> getAllTestedLabsDetails(){
    JSON2ApexNationStateTestCounts json2ApexNationStateTestCountsList;
    List<TestedWrapperDetails> testedWrapperDetailsList= new List<TestedWrapperDetails>();
    try {
        HttpResponse testedWraperResponse= CoronaStateWiseApex.getNationalwideSeriesAPI();
        if(testedWraperResponse.getStatusCode() == 200){
            json2ApexNationStateTestCountsList=JSON2ApexNationStateTestCounts.parse(testedWraperResponse.getBody());
            for(JSON2ApexNationStateTestCounts.Tested obj:json2ApexNationStateTestCountsList.tested){
                TestedWrapperDetails testedWrapper= new TestedWrapperDetails();
                testedWrapper.source=obj.source;
                testedWrapper.testsconductedbyprivatelabs=obj.testsconductedbyprivatelabs;
                testedWrapper.totalindividualstested=obj.totalindividualstested;
                testedWrapper.totalpositivecases=obj.totalpositivecases;
                testedWrapper.totalsamplestested=obj.totalsamplestested;
                testedWrapper.updatetimestamp=obj.updatetimestamp;
                testedWrapperDetailsList.add(testedWrapper);
            }
        }
    } catch(Exception e){
        System.debug('Exception in getAllTestedLabsDetails:::'+e.getMessage()+'~~~~Line:::'+e.getLineNumber());
    }
    System.debug('testedWrapperDetailsList:::::'+testedWrapperDetailsList);
    System.debug('testedWrapperDetailsList. size:::'+testedWrapperDetailsList.size());
    return testedWrapperDetailsList;
}

@AuraEnabled
public static List<CasesTimeSeriesWrapper> getCaseTimeSeriesDetails(){
    JSON2ApexNationStateTestCounts json2ApexNationStateTestCountsList;
    List<CasesTimeSeriesWrapper> casesTimeSeriesList= new List<CasesTimeSeriesWrapper>();
    try{
        HttpResponse testedWraperResponse= CoronaStateWiseApex.getNationalwideSeriesAPI();
        if(testedWraperResponse.getStatusCode() == 200){
            json2ApexNationStateTestCountsList=JSON2ApexNationStateTestCounts.parse(testedWraperResponse.getBody());
            for(JSON2ApexNationStateTestCounts.cases_time_series obj:json2ApexNationStateTestCountsList.cases_time_series){
                CasesTimeSeriesWrapper caseTimeSeries= new CasesTimeSeriesWrapper();
                caseTimeSeries.dailyconfirmed=Integer.valueOf(obj.dailyconfirmed);
                caseTimeSeries.dailydeceased=Integer.valueOf(obj.dailydeceased);
                caseTimeSeries.dailyrecovered=Integer.valueOf(obj.dailyrecovered);
                caseTimeSeries.dateUpdated=obj.dates;
                caseTimeSeries.totalconfirmed=Integer.valueOf(obj.totalconfirmed);
                caseTimeSeries.totaldeceased=Integer.valueOf(obj.totaldeceased);
                caseTimeSeries.totalrecovered=Integer.valueOf(obj.totalrecovered);
                casesTimeSeriesList.add(caseTimeSeries);
            }
        }
    } catch(Exception e){
        System.debug('Exception in getCaseTimeSeriesDetails::::'+e.getLineNumber()+'~~~~Message::'+e.getMessage());
    }
    System.debug('casesTimeSeriesList::::'+casesTimeSeriesList);
    System.debug('casesTimeSeriesList.Size::::'+casesTimeSeriesList.size());
    return casesTimeSeriesList;
}

public class TestedWrapperDetails {

    @AuraEnabled
    public String source {get;set;}
    @AuraEnabled
    public String testsconductedbyprivatelabs {get;set;}
    @AuraEnabled
    public String totalindividualstested {get;set;}
    @AuraEnabled
    public String totalpositivecases {get;set;}
    @AuraEnabled
    public String totalsamplestested {get;set;}
    @AuraEnabled
    public String updatetimestamp {get;set;}
}

public class StateWiseDetails{
    @AuraEnabled
    public String state {get;set;}
    @AuraEnabled
    public Integer active {get;set;}
    @AuraEnabled
    public Integer recovered {get;set;}
    @AuraEnabled
    public Integer deaths {get;set;}
    @AuraEnabled
    public Integer confirmed {get;set;}
}

public class CasesTimeSeriesWrapper{
    @AuraEnabled
    public Integer dailyconfirmed {get;set;}
    @AuraEnabled
    public Integer dailydeceased {get;set;}
    @AuraEnabled
    public Integer dailyrecovered {get;set;}
    @AuraEnabled
    public String dateUpdated;
    @AuraEnabled
    public Integer totalconfirmed {get;set;}
    @AuraEnabled
    public Integer totaldeceased {get;set;}
    @AuraEnabled
    public Integer totalrecovered {get;set;}
}

public class StateWrapper{
    @AuraEnabled
    public Integer confirmed {get;set;}
    @AuraEnabled
    public String districtName {get;set;}
}

}