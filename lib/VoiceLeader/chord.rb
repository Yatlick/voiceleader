class Music

  def chord_pairs
    pairs = []
    self.chords.each_cons(2) { |c, d| pairs << [c, d] }
    return pairs
  end

  def initialize(key)
    @chords = []
    @key = key
  end
  
  attr_reader :chords, :key
  attr_writer :chords

end

class Chord

  # Returns 2D array of intervals between voice parts
  #   form: [low voice, high voice, interval]
  def get_intervals
    ints = []
    pitch_set = @pitch_set.dup
    until pitch_set.empty?
      p_low = pitch_set.shift
      pitch_set.each { |p_hi| ints << p_hi - p_low }
    end
    low_voice = ['bass', 'bass', 'bass', 'tenor', 'tenor', 'alto']
    hi_voice = ['tenor', 'alto', 'soprano', 'alto', 'soprano', 'soprano']
    labeled_ints = [low_voice, hi_voice, ints].transpose
  end
  
  # Reduce chord to pitch classes, sort, and find intervals between consecutives
  def interval_loop
    pitches = @pitch_set.map { |p| p % 12 }
    pitches.uniq!
    pitches.sort!
    pitches << pitches[0] + 12 # To allow comparison between first and last pitches
    interval_loop = []
    pitches.each_cons(2) { |p, q| interval_loop << q - p }
    interval_loop
  end
  
  def get_type
    case self.interval_loop
    when [5, 4, 3], [4, 3, 5], [3, 5, 4]
      return 'Major'
    when [8, 4], [4, 8] # No fifth
      return 'Major'
    when [3, 4, 5], [4, 5, 3], [5, 3, 4]
      return 'Minor'
    when [9, 3], [3, 9] # No fifth
      return 'Minor'
    when [4, 4, 4]
      return 'Augmented'
    when [3, 3, 6], [3, 6, 3], [6, 3, 3]
      return 'Diminished'
    when [1, 4, 3, 4], [4, 3, 4, 1], [3, 4, 1, 4], [4, 1, 4, 3]
      return 'Major 7th'
    when [2, 4, 3, 3], [4, 3, 3, 2], [3, 3, 2, 4], [3, 2, 4, 3]
      return 'Dominant 7th'
    when [2, 4, 6], [4, 6, 2], [6, 2, 4]
      return 'Dominant 7th' # No fifth
    when [2, 3, 4, 3], [3, 4, 3, 2], [4, 3, 2, 3], [3, 2, 3, 4]
      return 'Minor 7th'
    when [3, 3, 3, 3]
      return 'Diminished 7th'
    when [2, 3, 3, 4], [3, 3, 4, 2], [3, 4, 2, 3], [4, 2, 3, 3]
      return 'Half-Diminished 7th'
    when [4, 2, 4, 2], [2, 4, 2, 4]
      return 'French Augmented 6th'
    else
      return 'Unknown Chord'
    end
  end

  def get_parts
    chord_possibilities = {
      'Major' => [8, 4, 7, nil],
      'Minor' => [9, 3, 7, nil],
      'Augmented' => 'n/a',
      'Diminished' => [3, 9, 6, nil],
      'Major 7th' => [1, 9, 3, 11],
      'Dominant 7th' => [2, 4, 7, 10],
      'Minor 7th' => [2, 8, 4, 10],
      'Diminished 7th' => 'n/a',
      'Half-Diminished 7th' => [2, 5, 8, 10],
      'Unknown Chord' => 'unknown'
    }
    values = chord_possibilities[@type]
    parts = {}
    parts_reverse = {'root' => [], 'third' => [], 'fifth' => [],
                     'seventh' => [], 'n/a' => [], 'unknown' => [], 'error' => []}
    
    @pitches.each do |voice, pitch|
      poss_int = @pitch_set.map { |q| (pitch - q) % 12 }
      if values == 'n/a' || values == 'unknown'
        parts[voice] = values
        parts_reverse[values] << voice
      elsif poss_int.include?(values[0])
        parts[voice] = 'root'
        parts_reverse['root'] << voice
      elsif poss_int.include?(values[1])
        parts[voice] = 'third'
        parts_reverse['third'] << voice
      elsif poss_int.include?(values[2])
        parts[voice] = 'fifth'
        parts_reverse['fifth'] << voice
      elsif values[3] && poss_int.include?(values[3])
        parts[voice] = 'seventh'
        parts_reverse['seventh'] << voice
      else
        parts[voice] = 'error'
        parts_reverse['error'] << voice
      end 
    end

    return [parts, parts_reverse]
  end
  
  def get_pitch_names
    sharp_keys = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
    flat_keys = ['C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B']
    names = @music.key['type'] == 'sharp' ? sharp_keys : flat_keys
    pitch_names = {}
    @pitches.each do |voice, pitch|
      pitch %= 12
      pitch_names[voice] = names[pitch]
    end
    return pitch_names
  end
  
  def get_name
    root_voice = @parts_reverse['root'][0]
    return "#{@pitch_names[root_voice]} #{@type}"
  end
  
  def initialize(pitches, music)
    @music = music
    @pitch_set = pitches
    @pitches = {'bass' => pitches[0], 
                'tenor' => pitches[1], 
                'alto' => pitches[2],
                'soprano' => pitches[3]}
    @pitch_names = self.get_pitch_names
    @type = self.get_type
    @parts, @parts_reverse = self.get_parts
    @intervals = self.get_intervals
    @mistakes = []
  end
  
  attr_reader :pitch_set, :pitches, :type, :parts, :parts_reverse, :intervals, :mistakes, :music, :pitch_names
  attr_writer :mistakes

end
