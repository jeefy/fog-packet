module Fog
  module Compute
    class Packet
      # Real
      class Real
        def list_snapshots(volume_id, params = {})
          request(
            :expects => [200],
            :method => "GET",
            :path => "/storage/" + volume_id + "/snapshots",
            :params => params
          )
        end
      end

      # Mock
      class Mock
        def list_snapshots(_volume_id, _params = {})
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "snapshots" => [
              {
                "id" => "39eaca27-3c42-4a98-acbd-0341503294f2",
                "status" => "available",
                "timestamp" => "1520630798.001449414",
                "created_at" => "2018-03-09T21:26:38.001Z",
                "volume" => {
                  "href" => "/storage/64ad028f-ad75-4092-b974-531a80d7860d"
                }
              }
            ]
          }

          response
        end
      end
    end
  end
end
