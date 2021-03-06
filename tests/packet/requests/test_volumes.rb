require_relative "../../../lib/fog-packet"

# TestVolumes
class TestVolumes < Minitest::Test
  def self.test_order
    :alpha
  end

  def setup
    # Establish Connection
    @compute = Fog::Compute::Packet.new(:packet_token => ENV["PACKET_TOKEN"])
    @project_id = "93125c2a-8b78-4d4f-a3c4-7367d6b7cca8"
  end

  def test_request_a_create_volume
    dev = {
      :hostname => "test01",
      :facility => "ewr1",
      :plan => "baremetal_0",
      :operating_system => "coreos_stable"
    }

    response = @compute.create_device(@project_id, dev)

    @@device_id = response.body["id"]

    loop do
      response = @compute.get_device(@@device_id)
      break if response.body["state"] == "active"
      sleep(3)
    end

    options = {
      :facility => "ewr1",
      :plan => "storage_1",
      :size => 20,
      :description => "test description",
      :billing_cycle => "hourly"
    }

    response = @compute.create_volume(@project_id, options)

    assert_equal response.status, 201
    @@volume_id = response.body["id"]
    
    loop do
      response = @compute.get_volume(@@volume_id)
      break if response.body["state"] == "active"
      sleep(3)
    end
  end

  def test_request_b_get_volume
    response = @compute.get_volume(@@volume_id)

    assert_equal response.status, 200
  end

  def test_request_c_update_volume
    options = {
      :size => 30
    }
    response = @compute.update_volume(@@volume_id, options)

    assert_equal response.status, 200
    assert_equal response.body["size"], options[:size]
  end

  def test_request_d_list_volumes
    response = @compute.list_volumes(@project_id)

    assert !response.body["volumes"].empty?
  end

  def test_request_e_attach_volume
    response = @compute.attach_volume(@@volume_id, @@device_id)
    @@attachment_id = response.body["id"]

    assert_equal 201, response.status
  end

  def test_request_f_detach_volume
    response = @compute.detach_volume(@@attachment_id)
    assert_equal 204, response.status
  end

  def test_request_g_delete_volume
    response = @compute.delete_volume(@@volume_id)
    assert_equal response.status, 204
  end

  def test_request_h_cleanup
    @compute.delete_device(@@device_id)
  end
end
