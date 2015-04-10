require_relative '../../../lib/wonga/daemon/scheduled_start_event_handler'
require 'spec_support/shared_daemons'
require 'wonga/daemon/pantry_api_client'
require 'logger'

RSpec.describe Wonga::Daemon::ScheduledStartEventHandler do
  let(:api_client) { instance_double(Wonga::Daemon::PantryApiClient, send_get_request: instances, send_post_request: true) }
  let(:instances) { [1] }
  let(:logger) { instance_double(Logger).as_null_object }

  subject { described_class.new(api_client, logger) }
  it_behaves_like 'scheduled task'

  describe '#run' do
    it 'gets list of instances scheduled for start' do
      expect(api_client).to receive(:send_get_request).with('/api/ec2_instances/ready_for_start')
      subject.run
    end

    it 'sends shut down request for each instance' do
      expect(api_client).to receive(:send_post_request).with('/api/ec2_instances/1/start', {})
      subject.run
    end
  end
end
