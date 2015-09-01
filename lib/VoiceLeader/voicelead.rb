class Mistake

  def initialize(type, value)
    @type = type
    @value = value
  end

  attr_reader :type, :value
end

module VoiceLead
  
  def VoiceLead.parallel(chord_a, chord_b, type)
    parallel_possibilities = {'fifths' => 7, 'octaves' => 0, 'unisons' => 'U'}
    interval = parallel_possibilities[type]
    set_a = chord_a.intervals
    set_b = chord_b.intervals
    parallels = []
    
    # Creates array of index values containing desired interval (for intervals_a)
    if interval == 'U'
      indexes = set_a.each_index.select { |i| set_a[i][2] == 0 }
    else
      indexes = set_a.each_index.select { |i| set_a[i][2] != 0 &&
                                          set_a[i][2] % 12 == interval }
    end
     
    # Find parallel motion
    parallels = indexes.select { |i| set_a[i][2] == set_b[i][2] }
      
    # Return mistake string
    mistakes = []
    parallels.each do |p| 
      mistakes << Mistake.new("Parallel #{type.capitalize}", 
                              "Between the #{set_b[p][0]} and #{set_b[p][1]}")
    end
    
    return mistakes
  end

  # Check for proper downward resolution of 7ths
  def VoiceLead.sevenths(chord_a, chord_b, none)
    return [] unless chord_a.parts.has_value?('seventh')
    voices = chord_a.parts.map{ |k,v| v == 'seventh' ? k : nil }.compact
        
    mistakes = []
    voices.each do |v|
      leap = chord_a.pitches[v] - chord_b.pitches[v]
      unless (1..2).include?(leap)
        mistakes << Mistake.new('Improperly resolved 7th',
                                "In the #{v}")
      end
    end

    return mistakes
  end
  
end
