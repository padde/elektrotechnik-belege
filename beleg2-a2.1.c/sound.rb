# = Description
# This program contains a class called +Sound+, which enables the user
# to generate arbitrary samples and to save them to a WAV file.
# 
# When the file is executed on its own, it generates four WAV files to
# show how the following sine functions sound in comparison:
# - sin(omega*t)
# - sin^2(omega*t) which is equivalent to 1/2 * ( 1 -   cos(2*omega*t) )
# - sin^3(omega*t) which is equivalent to 1/4 * (     3*sin(  omega*t) - sin(3*omega*t) )
# - sin^4(omega*t) which is equivalent to 1/8 * ( 3 - 4*cos(2*omega*t) + cos(4*omega*t) )
#
# Author::    Patrick Oscity  (mailto:patrick.oscity@uni-weimar.de)
# Copyright:: Copyright (c) 2011 Bauhaus-University Weimar
# License::   Distributes under the same terms as Ruby

require 'rubygems'
require 'wavefile'


# = Description
# This class is used to generate arbitrary audio samples and write
# them to a specified file. 
# 
# = Example Usage
#   # set frequency to 200 Hz
#   omega = 2 * Math::PI * 200
#   
#   # generate a 200 Hz sine wave
#   sound = Sound.new
#   sound.generate_samples do |t|
#     Math::sin(omega*t)
#   end
#   sound.save "sine.wav"
#
class Sound
  # channels: 1 (mono)
  CHANNELS        = 1
  # samples per second: 44100
  SAMPLING_RATE   = 44100.0
  # bits per sample: 16
  BITS_PER_SAMPLE = 16
  # duration: 3 seconds
  DURATION        = 3.0
  
  def initialize
    # array holding the samples
    @samples = []
  end
  
  # This method takes a block containing a function that generates
  # the samples
  # 
  # ==== Parameters
  # [+duration+] Duration of the sound, defaults to 3 seconds
  # 
  # ==== Block parameters
  # [+t+] Time variable passed to the block
  #
  def generate_samples( duration = DURATION )
    num_samples = SAMPLING_RATE * duration
  
    for i in 0...num_samples do
      t = i/SAMPLING_RATE
      @samples.push yield(t)
    end
  end

  # This method writes the given samples to a WAV file.
  # 
  # ==== Parameters
  # [+filename+] Filename where the WAV data is written to
  #
  def save( filename )
    file = WaveFile.new(CHANNELS, SAMPLING_RATE, BITS_PER_SAMPLE)
    file.sample_data = @samples
    file.save filename
  end
end


# The following code is only executed if the file is _not_ included
# from another file, but run on its own.
if __FILE__ == $0
  # f = 1/T
  # omega = 2π/T
  # => omega = 2*π*T 
  omega = 2 * Math::PI * 65.0

  # generate samples for sin(omega*t), ..., sin^4(omega*t)
  # and write them to a WAV file
  for i in 1..4 do
    sound = Sound.new
    sound.generate_samples do |t|
      Math::sin(omega*t) ** i
    end
    sound.save "sinus#{i}.wav"
  end
end