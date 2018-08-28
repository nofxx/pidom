# Pidom

Temperature controlling, easy way.  It uses an improved PID algorithm to
decrease overshoots and regulate based on continued inputs.

## Installation

Add this line to your application's Gemfile:

    gem 'pidom'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pidom

## Usage

To start, create an instance of Pidom::PID.  The PID algorithm can be configured with
custom minimum and maximum values for ease of integration with external control systems
(PWM-controlled heating elements, for example).  Once created, run `Pidom::PID#control`
in your control loop, feeding it sensor data.

## Proportional on Measurement

All thanks to

http://brettbeauregard.com/blog/category/pid/

Also:

https://controlguru.com/pid-control-and-derivative-on-measurement/

### Minimum Interval Calculation

The algorithm being used is minimum interval and will not recalibrate until the time interval
has passed before recalibrating.  This helps mitigate excess compensation and inconsistent
adjustment. The update interval is also configurable in Pidom with the `interval` option.

### Directional Control

When handling cooling-based temperature control, negative values are a pain for
translation.  To assist with this, Pidom uses a directional control parameter.  The two
possible states are `:direct` and `:reverse`.  When using `:reverse`, negative values
are inverted.

### Tuning

Pidom's PID is manually tuned with the `tune` method, which takes a Kp, Ki, and Kd value. By
default, Pidom will set them to 1.0.  `Pidom::PID` also can take the kp, ki, and kd options
in the constructor call.

## Example

``` ruby
require 'pidom'

pidom = Pidom::PID.new(interval: 1000, minimum: 0, maximum: 1000, direction: :direct)
pidom.tune(9.0, 25.0, 6.0) # Set Kp, Ki, and Kd
pidom.setpoint = 100.0       # Set target temperature

while input = read_sensor()   # Replace read_sensor with your external system
  output = pidom.control(input)
  # output is a value betwen minimum and maximum. This can be used for thresholds or
  # PWM-based control
end
```

For more examples check out the [examples](examples/) directory.

## Temper

This is a rewrite of 'temper-control' gem with PonM algorithm.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
