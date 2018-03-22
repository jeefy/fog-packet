module Fog
  module Compute
    # Packet
    class Packet < Fog::Service
      API_VERSION = "v1".freeze

      SUCCESS_CODES = [200, 201, 202, 204].freeze

      requires :packet_token

      recognizes :packet_url

      # Models
      model_path "packet/models"

      # model :project
      # collection :projects

      model :plan
      collection :plans

      model :project
      collection :projects

      model :facility
      collection :facilities

      model :device
      collection :devices

      model :project
      collection :projects

      model :operating_system
      collection :operating_systems

      model :ip
      collection :ips

      model :snapshot
      collection :snapshots

      model :volume
      collection :volumes

      model :virtual_network
      collection :virtual_networks

      # Requests
      request_path "packet/requests"

      request :list_plans
      request :list_projects
      request :get_project
      request :create_project
      request :delete_project
      request :list_facilities
      request :list_operating_systems

      request :create_device
      request :list_devices
      request :get_device
      request :delete_device
      request :update_device
      request :reboot_device
      request :poweron_device
      request :poweroff_device

      request :get_volume
      request :create_volume
      request :list_volumes
      request :delete_volume
      request :attach_volume
      request :detach_volume
      request :update_volume

      request :reserve_ip
      request :get_ip
      request :list_ips
      request :assign_ip
      request :unassign_ip
      request :create_snapshot
      request :delete_snapshot
      request :list_snapshots

      request :create_virtual_network
      request :list_virtual_networks
      request :delete_virtual_network
      request :assign_port
      request :unassign_port
      request :disbond_ports
      request :bond_ports

      # Real
      class Real
        def initialize(options = {})
          @packet_token = options[:packet_token]
          @base_url = "https://api.packet.net/"
          @version = ""
          @header = {
            "X-Auth-Token" => @packet_token,
            "Content-Type" => "application/json"
          }
          @connection = Fog::Core::Connection.new(@base_url)
        end

        def request(params)
          # Perform Request

          begin
            response = @connection.request(:method => params[:method],
                                           :path => params[:path],
                                           :headers => @header,
                                           :body => params[:body],
                                           :query => params[:params])
          rescue Excon::Errors::Unauthorized => error
            raise error
          rescue Excon::Errors::HTTPStatusError => error
            raise error
          rescue Excon::Errors::InternalServerError => error
            raise error
          rescue Fog::Errors::NotFound => error
            raise error
          end

          # Parse body
          response.body = Fog::JSON.decode(response.body) if response.body != ""

          #
          # Check for server error
          if response.status == 500
            raise "Internal Server Error. Please try again."
          end
          # Raise exception if a bad status code is returned
          # unless SUCCESS_CODES.include? response.status
          #   raise response.status
          # end

          response
        end
      end

      # Mock
      class Mock
        def initialize(options = {})
          @packet_token = options[:packet_token]
        end

        def data
          self.class.data[@packet_token]
        end
      end
    end
  end
end