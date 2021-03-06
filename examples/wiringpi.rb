###############
#
# This example uses WiringPi-Ruby (https://github.com/WiringPi/WiringPi-Ruby)
# to read sensor data from GPIO 7, feed it to Pidom, and adjust the heat
# control via PWM based on the resulting power level returned from Pidom.
# It is controlled for 60s.
#
###############
require 'wiringpi'

# Setup GPIO for sensor data and heat control
io = WiringPi::GPIO.new
SENSOR_PIN = 7
PWM_PIN = 11
io.mode SENSOR_PIN, WiringPi::INPUT
io.mode PWN_PIN, WiringPi::PWM_OUTPUT

# Setup PID

pid = Pidom::PID.new kp: 1.0, ki: 1.0, kd: 1.0, maximum: 100
pid.setpoint = 175.5 # Target temp - Degrees Fahrenheit

# Control temp for 60 seconds
stop = Time.now + 60

while Time.now < stop
  temperature = io.read SENSOR_PIN
  adjusted_power_level = pid.control temperature
  io.pwmWrite PWM_PIN, adjusted_power_level
end
