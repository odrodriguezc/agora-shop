Rails.application.configure do
  # Enable Lograge in dev and production for concise, structured logs
  config.lograge.enabled = Rails.env.development? || Rails.env.production?

  # Emit JSON for easy ingestion by log processors
  config.lograge.formatter = Lograge::Formatters::Logstash.new

  # Include useful request context and filter noisy params
  config.lograge.custom_payload do |controller|
    {
      request_id: controller.request.request_id,
      remote_ip: controller.request.remote_ip,
      ua: controller.request.user_agent
    }
  end

  config.lograge.custom_options = lambda do |event|
    params = event.payload[:params] || {}
    filtered = params.except("controller", "action", "format", "id")

    { params: filtered }
  end
end
