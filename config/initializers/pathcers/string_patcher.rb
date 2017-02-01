class String
  def determine_sql_type
    Sql::TYPES.each do |k, v|
      return k if self.type_phrase.include? v
    end
    nil
  end

  def type_phrase
    self[0...12]
  end

  def first_word
    partition(' ').first
  end
end
