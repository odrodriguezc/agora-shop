# # Broadcast Rails logs to Logstash when the feature flag is enabled.
# # Falls back to standard logging if the gem is unavailable or the host is not configured.

# require "active_support/broadcast_logger"
# require "active_support/logger_silence"
# require "active_support/tagged_logging"

# logstash_enabled = ActiveModel::Type::Boolean.new.cast(
#   ENV.fetch("LOGSTASH_LOGGING_ENABLED", false)
# )

# return unless logstash_enabled

# begin
#   require "logstash-logger"
#   require "logstash/event"
# rescue LoadError => e
#   Rails.logger.warn("[logstash] logstash-logger gem missing: #{e.message}")
#   return
# end

# host = ENV["LOGSTASH_HOST"].presence or raise "LOGSTASH_HOST must be set when LOGSTASH_LOGGING_ENABLED=true"
# port = Integer(ENV.fetch("LOGSTASH_PORT", 5514))
# transport = ENV.fetch("LOGSTASH_TRANSPORT", "tcp")
# ssl_enable = ActiveModel::Type::Boolean.new.cast(ENV.fetch("LOGSTASH_SSL_ENABLED", false))
# ssl_ca_file = ENV["LOGSTASH_SSL_CA_PATH"].presence

# logstash_logger = LogStashLogger.new(
#   type: transport,
#   host: host,
#   port: port,
#   ssl_enable: ssl_enable,
#   ssl_ca_file: ssl_ca_file,
#   custom_fields: { service: "web", environment: Rails.env },
#   formatter: ->(_severity, _time, _progname, message) do
#     case message
#     when String then message
#     when LogStash::Event then message.to_json
#     else message.respond_to?(:to_json) ? message.to_json : message.to_s
#     end
#   end
# )

# existing_logger = Rails.logger

# unless existing_logger
#   require "active_support/logger"
#   existing_logger = ActiveSupport::Logger.new($stdout)
#   Rails.logger = existing_logger
# end

# base_logger = existing_logger.respond_to?(:logger) ? existing_logger.logger : existing_logger
# broadcast_logger = ActiveSupport::BroadcastLogger.new(base_logger, logstash_logger)

# if existing_logger.respond_to?(:logger=)
#   existing_logger.logger = broadcast_logger
# elsif existing_logger.equal?(base_logger)
#   Rails.logger = broadcast_logger
# else
#   Rails.logger = ActiveSupport::TaggedLogging.new(broadcast_logger)
# end
