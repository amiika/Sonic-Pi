
use_midi_defaults port: "casio_usb-midi", channel: 3
midi_pc 50

i = 36

def daa
  36.upto(96) do |i|
    sleep 0.12
    midi i, sustain: 0.25
  end
  96.downto(36) do |i|
    sleep 0.25
    midi i, sustain: 0.25
  end
end
6.times do
  5.times do
    in_thread do
      daa
    end
    sleep 0.5
  end
end