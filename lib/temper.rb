require 'temper/version'

module Temper
  # Le PID
  class PID
    attr_accessor :kp, :ki, :kd, :setpoint, :direction, :output

    def initialize(options = {})
      @interval = options[:interval] || 1000
      @last_time = 0.0
      @last_input = 0.0
      @integral_term = 0.0
      @output_maximum = options[:maximum] || 1000
      @output_minimum = options[:minimum] || 0

      @kp = options.delete(:kp)
      @ki = options.delete(:ki)
      @kd = options.delete(:kd)

      self.pom = options[:pom] ? true : false
      self.mode = options[:mode] || :auto
      self.direction = options[:direction] || :direct
    end

    def control(input)
      return unless @auto # manual mode

      now = Time.now.to_f
      time_change = (now - @last_time) * 1000

      return unless time_change >= @interval
      error = @setpoint - input

      calculate_proportional error
      calculate_integral error
      calculate_derivative input

      calculate_output

      @last_time = now
      @last_input = input

      @output
    end

    def calculate_proportional(error)
      @proportional_term = @kp * error
    end

    def calculate_integral(error)
      int = @integral_term + (@ki * error)

      if int > @output_maximum
        int = @output_maximum
      elsif int < @output_minimum
        int = @output_minimum
      end

      @integral_term = int
    end

    def calculate_derivative(input)
      @derivative_term = @kd * (input - @last_input)
    end

    def calculate_output
      out = @proportional_term + @integral_term - @derivative_term

      if out > @output_maximum
        out = @output_maximum
      elsif out < @output_minimum
        out = @output_minimum
      end

      @output = out
    end

    def tune kp, ki, kd
      return if kp < 0 || ki < 0 || kd < 0

      interval_seconds = (@interval / 1000.0)

      @kp = kp
      @ki = ki * interval_seconds
      @kd = kd / interval_seconds

      return if @direction == :direct
      @kp = 0 - @kp
      @ki = 0 - @ki
      @kd = 0 - @kd
    end

    def update_interval(new_interval)
      return unless new_interval > 0
      ratio = new_interval / @interval

      @ki *= ratio
      @kd /= ratio
      @interval = new_interval
    end

    def mode=(mode)
      @auto = mode == :auto
    end

    def mode
      @auto ? :auto : :manual
    end
  end
end
