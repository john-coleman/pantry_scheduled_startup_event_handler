module Wonga
  module Daemon
    class ScheduledStartEventHandler
      def initialize(api_client, logger)
        @api_client = api_client
        @logger = logger
      end

      def run
        ids = @api_client.send_get_request('/api/ec2_instances/ready_for_start')
        if ids.any?
          @logger.info("Instances ready for start are #{ids}")
          ids.each do |instance_id|
            @api_client.send_post_request("/api/ec2_instances/#{instance_id}/start", {})
          end
        else
          @logger.info('No instances scheduled for start')
        end
      end
    end
  end
end
