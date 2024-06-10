class WeightedNotePool
  
  def initialize(weighted_notes)
    @notes = []
    weighted_notes.each{|wn|
      for i in 0..wn[1]
        @notes.push(wn[0])
      end
    }
  end
  
  def get_note
    return @notes.choose
  end
end