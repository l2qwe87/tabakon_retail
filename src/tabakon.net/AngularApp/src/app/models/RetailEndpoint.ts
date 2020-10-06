
export class RetailEndpointExtData{
    public retailVersion? : RetailVersion
    public retailExtConfiguration? : RetailExtConfiguration
}

export class RetailEndpoint{
    public retailEndpointIdentity : string;
    public retailEndpointName : string;
    public retailEndpointHost : string;
    public retailEndpointUrl : string;
    public markAsDeleted : string;

    public extData : RetailEndpointExtData;
}


class AbstractCacheEntity{
    public lastCheck : Date
    public retailEndpointIdentity : string;
    public jsonData : string;
}

export class RetailVersion extends AbstractCacheEntity{

}

export class RetailExtConfiguration extends AbstractCacheEntity{

}
