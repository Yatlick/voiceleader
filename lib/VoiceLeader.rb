require './lib/VoiceLeader/chord.rb'
require './lib/VoiceLeader/voicelead.rb'

def make_music(key, notes)
  key = key.split(" ")
  key = {'type' => key[0], 'number' => key[1].to_i}
  music = Music.new(key)
  
  pitches = []
  notes.each do |n|
    pitches << n.split(",").map(&:to_i)
  end
  pitches = pitches.transpose
  pitches.each { |p| music.chords << Chord.new(p, music) }
  
  return music
end

def find_mistakes(music, options)
  option_possibilities = {
    'p_fifths' => [:parallel, 'fifths'],
    'p_octaves' => [:parallel, 'octaves'],
    'p_unisons' => [:parallel, 'unisons'],
    'sevenths' => [:sevenths, 'none']  # unsure how to call variable arguments in loop
  }
  music.chord_pairs.each do |chord_a, chord_b|
    options.each do |o|
      chord_a.mistakes += VoiceLead.send(option_possibilities[o][0], chord_a, 
                                         chord_b, option_possibilities[o][1])
    end
  end
end
      
      
      
      
