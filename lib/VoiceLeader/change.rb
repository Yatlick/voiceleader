class Change
  
  def initialize(chord1, chord2)
    @bass = chord1.pitches[0] - chord2.pitches[0]
    @tenor = chord1.pitches[1] - chord2.pitches[1]
    @alto = chord1.pitches[2] - chord2.pitches[2]
    @soprano = chord1.pitches[3] - chord2.pitches[3]
    @mistakes = {}
  end
  
  attr_reader :bass, :tenor, :alto, :soprano, :mistakes
  attr_writer :mistakes
end

class Cadence < Change
end
