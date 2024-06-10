use_bpm 140

run_file "/Users/admiralbolt/git/sonicpi/weighted_note_pool.rb"

in_thread(name: :metronome) do
  loop do
    cue :beat
    sleep 1
  end
end

in_thread(name: :kick_drum) do
  counter = 0
  loop do
    sync :beat
    sample :drum_bass_hard, release: 0.3
    counter += 1
    if counter >= 9
      cue :hello_hat
    end
    if counter >= 16
      cue :clap_you_fucker
    end
    if counter >= 17
      cue :activate_chords
    end
    if counter >= 0
      cue :stank
    end
    if counter >= 33
      cue :activate_warble
    end
  end
end

in_thread(name: :hi_hat) do
  sync :hello_hat
  loop do
    sample :drum_cymbal_closed, release: rrand(0.3, 0.5), amp: rrand(0.9, 1.1), cutoff: rrand(70, 130)  if rand < 0.85
    sleep 0.25
  end
end

in_thread(name: :clap) do
  sync :clap_you_fucker
  with_fx :reverb do |r|
    loop do
      if rand < 0.75
        control r, mix: rrand(0.4, 0.6)
        control r, damp: rrand(0.5, 0.6)
        control r, room: rrand(0.6, 0.8)
        sample :perc_snap2
      end
      sleep 2
    end
  end
end

in_thread(name: :chords) do
  sync :activate_chords
  
  progression = [
    [:C3, :m9],
    [:D3, "m7b5"],
    [:Eb3, :M7],
    [:Cs3, '7+5-9'],
  ].ring
  
  with_fx :reverb, mix: 0.65, room: 1 do
    with_fx :echo, mix: 0.4, phase: 0.25, decay: 8 do
      live_loop :chords_loop do
        next_val = progression.tick
        play chord(next_val[0], next_val[1]), attack: rrand(0, 0.2), pan: rrand(-0.3, 0.3), sustain: rrand(0.5, 1.5), cutoff: rrand(70, 100), pitch: rrand(-0.1, 0.1)
        sleep 4
      end
    end
  end
end

in_thread(name: :bass) do
  sync :stank
  use_synth :pluck
  
  note_pool = WeightedNotePool.new([[36, 10], [48, 5], [24, 2], [38, 6], [39, 5], [41, 3], [43, 3], [47, 2]])
  
  loop do
    play note_pool.get_note(), amp: rrand(1, 1.2), release: rrand(0.1, 0.2), sustain: rrand(0.3, 0.5)
    sleep [0.25, 0.25, 0.25, 0.5, 0.5, 0.75].choose
  end
end

in_thread(name: :high_warble) do
  sync :activate_warble
  use_synth :dtri
  
  note_pool = WeightedNotePool.new([[72, 7], [84, 7], [86, 7], [83, 2], [79, 4], [77, 3], [75, 3]])
  with_fx :reverb, room: 1, mix: 0.9 do
    sound = play note_pool.get_note(), amp: 0.08, sustain: 100, note_slide: 1
    loop do
      control sound, note: note_pool.get_note()
      sleep 4
    end
  end
end