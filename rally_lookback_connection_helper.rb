require 'httpclient'
require 'pp'
require 'json'

class RallyLookbackConnectionHelper
    attr_reader :lb_http_client

    def initialize(config)

        @lbapi_http_client                                = HTTPClient.new
        @lbapi_http_client.protocol_retry_count           = 2
        @lbapi_http_client.connect_timeout                = 300
        @lbapi_http_client.receive_timeout                = 300
        @lbapi_http_client.send_timeout                   = 300
        @lbapi_http_client.transparent_gzip_decompression = true

        # LBAPI base url
        @base_url                                         = config[:base_url]
        @lbapi_version                                    = config[:lbapi_version]
        @api_key                                          = config[:api_key]
        @username                                         = config[:username]
        @password                                         = config[:password]

        # Request Headers
        @request_headers                                  = {}
        @request_headers["Content-Type"]                  = "application/json"

        # Rally Workspace
        @rally_workspace_objectid                         = config[:workspace_objectid]
        if @api_key.nil? then
            set_client_auth(@base_url, @username, @password)
        else
            @request_headers[:ZSESSIONID]                = @api_key
        end
    end

    def set_client_auth(base_url, username, password)
        @lbapi_http_client.set_auth(@base_url, username, password)
        @lbapi_http_client.www_auth.basic_auth.challenge(@base_url)
    end

    def make_query_url()
        return "#{@base_url}/analytics/#{@lbapi_version}/service/rally/workspace/#{@rally_workspace_objectid}/artifact/snapshot/query"
    end

    def make_query_req(req_type, query_object)
        args = {:header => @request_headers, :body => query_object.to_json}
        req_url = make_query_url()

        req = {
            :method => req_type,
            :url => URI.parse(URI.encode(req_url.strip)),
            :args => args
        }
        return req
    end

    def query(find_object)

        query_req = make_query_req(:post, find_object)
        # Make request against Rally LBAPI endpoint and get response
        response = @lbapi_http_client.request(query_req[:method], query_req[:url], query_req[:args])

        response_json = JSON.parse(response)

        return response_json
    end

end