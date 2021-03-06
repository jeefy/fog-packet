module Fog
  module Compute
    class Packet
      # Real
      class Real
        def bond_ports(port_id, bulk_enable)
          request(
            :expects => [200],
            :method => "POST",
            :path => "/ports/" + port_id + "/bond?bulk_enable=" + (bulk_enable ? "true" : "false")
          )
        end
      end

      # Mock
      class Mock
        def bond_ports(_port_id, _bulk_enable)
          response = Excon::Response.new
          response.status = 200
          response
        end
      end
    end
  end
end
