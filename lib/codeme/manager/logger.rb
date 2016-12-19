require 'logger'

module Codeme
  module Manager
    class Logger < ::Logger
      module Colors
        NOTHING      = '0;0'
        BLACK        = '0;30'
        RED          = '0;31'
        GREEN        = '0;32'
        BROWN        = '0;33'
        BLUE         = '0;34'
        PURPLE       = '0;35'
        CYAN         = '0;36'
        LIGHT_GRAY   = '0;37'
        DARK_GRAY    = '1;30'
        LIGHT_RED    = '1;31'
        LIGHT_GREEN  = '1;32'
        YELLOW       = '1;33'
        LIGHT_BLUE   = '1;34'
        LIGHT_PURPLE = '1;35'
        LIGHT_CYAN   = '1;36'
        WHITE        = '1;37'

        SCHEMA = {
          STDOUT => %w[nothing green brown red purple cyan],
          STDERR => %w[nothing green yellow light_red light_purple light_cyan],
        }
      end

      class << self
        def method_missing(method, *args, &block)
          Manager.logger.send(method, *args, &block)
        end
      end

      alias format_message_colorless format_message

      def initialize(*args)
        super
        self.formatter = proc do |severity, datetime, progname, message|
          datetime = datetime.strftime("%Y-%m-%d %H:%M:%S")
          "[#{datetime}] #{severity}\t: #{message}\n"
        end
      end

      def format_message(level, *args)
        if schema[Logger.const_get(level.sub "ANY", "UNKNOWN")].to_s.upcase
          color = begin
                    Logger::Colors.const_get \
                      schema[Logger.const_get(level.sub "ANY", "UNKNOWN")].to_s.upcase
          rescue NameError
            "0;0"
          end
          "\e[#{ color }m#{ format_message_colorless(level, *args) }\e[0;0m"
        else
          format_message_colorless(level, *args)
        end
      end

      def schema
        Logger::Colors::SCHEMA[@logdev.dev] || Logger::Colors::SCHEMA[STDOUT]
      end
    end
  end
end
