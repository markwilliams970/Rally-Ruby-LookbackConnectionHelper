require './rally_lookback_connection_helper.rb'
require 'json'

lookback_helper_conf = {
    :base_url             => "https://rally1.rallydev.com",
    :lbapi_version        => "v2.0",
    :username             => "user@company.com",
    :password             => "t0p$3cr3t",
    #:api_key              => "_VAX5j9iaGt3AgrmxZxHamhadCwlwfGNQ3iriQ89Sb3",
    :workspace_objectid   => "12345678910"
}

@lookback_helper = RallyLookbackConnectionHelper.new(lookback_helper_conf)

query_obj = {
    "find" => {
        "FormattedID" => "DE9",
        "__At" => "current"
    },
    "fields" => true,
    "start" => 0,
    "pagesize" => 10,
    "removeUnauthorizedSnapshots" => true
}

response = @lookback_helper.query(query_obj)

puts JSON.pretty_generate(response)