require './lib/VoiceLeader/chord.rb'
require './lib/VoiceLeader/voicelead.rb'

def make_music(key, notes)
  pitches = []
  notes.each do |n|
    pitches << n.split(",").map(&:to_i)
  end
  pitches = pitches.transpose
  
  chords = []
  pitches.each { |p| chords << Chord.new(p) }
  
  music = Music.new(key, chords)
end

def print_info(music)
  html_names = "<h1>Each Chord Type</h1>\n"
  
  music.chords.each do |c|
    html_names += "<p>#{c.name}</p>\n"
  end
  
  return html_names
end

def find_mistakes(music, options)
  option_possibilities = {
    'p_fifths' => [:parallel, 'fifths'],
    'p_octaves' => [:parallel, 'octaves'],
    'p_unisons' => [:parallel, 'unisons'],
    'sevenths' => [:sevenths, 'none']  # unsure how to call variable arguments in loop
  }
  all_mistakes = {}
  chord_number = 0
  music.chord_pairs.each do |chord_a, chord_b|
    chord_number += 1
    pair_mistakes = []
    
    options.each do |o|
      mistakes = VoiceLead.send(option_possibilities[o][0], chord_a, chord_b, option_possibilities[o][1])
      pair_mistakes << mistakes
    end

    all_mistakes["Chord ##{chord_number}"] = pair_mistakes.flatten unless pair_mistakes.flatten.empty?
  end
  return all_mistakes
end
      
      
      
      
