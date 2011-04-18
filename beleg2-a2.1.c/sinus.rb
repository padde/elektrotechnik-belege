require 'rubygems'
require 'wavefile'


SAMPLING_FACTOR = 44100.0 / 2.0 / Math::PI

def write_to_new_file( samples, filename )
  w = WaveFile.new(1, 44100, 16)
  w.sample_data = samples
  w.save filename
end

def get_samples( duration = 3 )
  num_samples = 44100 * duration
  sample_data = []
  for i in 0...num_samples do
    sample_data.push yield(i)
  end
  sample_data
end


omega = 65.0/SAMPLING_FACTOR # 65 Hz Sinus

# aa) sin(wt)
samples = get_samples do |t|
  Math::sin(omega*t)
end
write_to_new_file samples, "sinus.wav"


# ab) sin2(wt)
samples = get_samples do |t|
  # 1/2 * ( 1 - Math::cos(2*omega*t) )
  Math::sin(omega*t) * Math::sin(omega*t)
end
write_to_new_file samples, "sinus2.wav"


# ac) sin3(wt)
samples = get_samples do |t|
  # 1/4 * (     3*Math::sin(  omega*t) - Math::sin(3*omega*t) ) * 65.0
  Math::sin(omega*t) * Math::sin(omega*t) * Math::sin(omega*t)
end
write_to_new_file samples, "sinus3.wav"


# ad) sin4(wt)
samples = get_samples do |t|
  # 1/8 * ( 3 - 4*Math::cos(2*omega*t) + Math::cos(4*omega*t) ) * 65.0
  Math::sin(omega*t) * Math::sin(omega*t) * Math::sin(omega*t) * Math::sin(omega*t)
end
write_to_new_file samples, "sinus4.wav"