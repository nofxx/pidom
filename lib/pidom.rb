require 'pidom/version'

module Pidom
  # Le PID
  class PID
    attr_accessor :kp, :ki, :kd, :pom, :setpoint, :direction, :output

    def initialize(options = {})
      @interval   = options[:interval] || 1000
      @last_time  = 0.0
      @last_input = 0.0
      @output_sum = 0.0
      @output_max = options[:maximum] || 1000
      @output_min = options[:minimum] || 0

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
      dinput = input - @last_input

      # Calculate Sum
      @output_sum += ki * error

      # Add Proportional on Measurement
      @output_sum -= kp * dinput if pom

      @output_sum = @output_max if @output_sum > @output_max
      @output_sum = @output_min if @output_sum < @output_min

      # Add Proportional on Error
      @output = pom ? 0 : kp * error

      # Finish PID
      @output += @output_sum - kd * dinput

      @output = @output_max if @output > @output_max
      @output = @output_min if @output < @output_min

      @last_time = now
      @last_input = input

      @output
    end

    def tune(kp, ki, kd, pom = nil)
      return if kp < 0 || ki < 0 || kd < 0

      @pom = pom == true
      interval_seconds = @interval / 1000.0

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
