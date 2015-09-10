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
    parallels = []
    
    # Creates array of index values containing desired interval (for chord_a.intervals)
    if interval == 'U'
      indexes = chord_a.intervals.each_index.select { |i| chord_a.intervals[i][2] == 0 }
    else
      indexes = chord_a.intervals.each_index.select { |i| chord_a.intervals[i][2] != 0 &&
                                                          chord_a.intervals[i][2] % 12 == interval }
    end
     
    # Find parallel motion
    parallels = indexes.select { |i| chord_a.intervals[i][2] == chord_b.intervals[i][2] && 
      chord_a.pitches[chord_a.intervals[i][0]] != chord_b.pitches[chord_b.intervals[i][0]]}
      
    # Return mistake string
    mistakes = []
    parallels.each do |p| 
      mistakes << Mistake.new("Parallel #{type.capitalize}", 
                              "Between the #{chord_b.intervals[p][0]} and #{chord_b.intervals[p][1]}")
    end
    
    return mistakes
  end

  # Check for proper downward resolution of 7ths
  def VoiceLead.sevenths(chord_a, chord_b, none)
    return [] if chord_a.parts_reverse['seventh'].empty?
        
    mistakes = []
    chord_a.parts_reverse['seventh'].each do |v|
      leap = chord_a.pitches[v] - chord_b.pitches[v]
      unless (1..2).include?(leap) && ['root', 'third', 'fifth'].include?(chord_b.parts[v])
        mistakes << Mistake.new('Improperly resolved 7th', "In the #{v}")
      end
    end
    return mistakes
  end
  
end
