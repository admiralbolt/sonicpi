# Welcome to Sonic Pi
set :bpm, 100

live_loop :flibble do
  use_bpm get(:bpm)
  sample :bd_haus, rate: 1
  sample :ambi_choir, rate: 0.6
  sleep 1
end