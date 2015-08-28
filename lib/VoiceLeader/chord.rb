class Music

  def initialize(key, chords_array)
    @chords = chords_array
    @length = chords_array.length
    @key = key
  end
  
  attr_reader :chords, :key, :length
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
      return 'Major Triad'
    when [8, 4], [4, 8] # No fifth
      return 'Major Triad'
    when [3, 4, 5], [4, 5, 3], [5, 3, 4]
      return 'Minor Triad'
    when [9, 3], [3, 9] # No fifth
      return 'Minor Triad'
    when [4, 4, 4]
      return 'Augmented Triad'
    when [3, 3, 6], [3, 6, 3], [6, 3, 3]
      return 'Diminished Triad'
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
      'Major Triad' => [8, 4, 7, nil],
      'Minor Triad' => [9, 3, 7, nil],
      'Augmented Triad' => 'n/a',
      'Diminished Triad' => [3, 9, 6, nil],
      'Major 7th' => [1, 9, 3, 11],
      'Dominant 7th' => [2, 4, 7, 10],
      'Minor 7th' => [2, 8, 4, 10],
      'Diminished 7th' => 'n/a',
      'Half-Diminished 7th' => [2, 5, 8, 10],
      'Unknown Chord' => 'unknown'
    }
    values = chord_possibilities[@name]
    members = []
    
    @pitch_set.each do |p|
      poss_int = @pitch_set.map { |q| (p - q) % 12 }
      if values == 'n/a'
        members << 'n/a'
      elsif values == 'unknown'
        members << 'unknown'
      elsif poss_int.include?(values[0])
        members << 'root'
      elsif poss_int.include?(values[1])
        members << 'third'
      elsif poss_int.include?(values[2])
        members << 'fifth'
      elsif values[3] && poss_int.include?(values[3])
        members << 'seventh'
      else
        members << 'error'
      end 
    end

    parts = {'bass' => members[0],
             'tenor' => members[1],
             'alto' => members[2],
             'soprano' => members[3]}
  end
  
  def initialize(pitches)
    @pitch_set = pitches
    @pitches = {'bass' => pitches[0], 
                'tenor' => pitches[1], 
                'alto' => pitches[2],
                'soprano' => pitches[3]}
    @name = self.get_type
    @parts = self.get_parts
    @intervals = self.get_intervals
    @mistakes = {}
  end
  
  attr_reader :pitch_set, :pitches, :name, :parts, :intervals, :mistakes
  attr_writer :mistakes

end
