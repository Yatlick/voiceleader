
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
    return nil if parallels.empty?
      
    # Return mistake string
    pairs = []
    parallels.each { |p| pairs << "#{set_b[p][0]} and #{set_b[p][1]}" }
    mistake_text = pairs.join(', ')
    return "Parallel #{type} between the #{mistake_text}."
  end

  # Check for proper downward resolution of 7ths
  def VoiceLead.sevenths(chord_a, chord_b)
    return nil unless chord_a.parts.has_value?('seventh')
    voices = chord_a.parts.map{ |k,v| v == 'seventh' ? k : nil }.compact
        
    mistakes = []
    voices.each do |v|
      leap = chord_a.pitches[v] - chord_b.pitches[v]
      mistakes << v unless (1..2).include?(leap)
    end
    return nil if mistakes.empty?

    mistake_text = mistakes.join(', ')
    return "Improperly resolved 7th in #{mistake_text}."
  end
  
end
