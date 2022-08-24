for i in ObjectSpace.each_object(Class).select { |cls| cls < Object }
  begin
    i.prepend(Module.new do
      def | other
        return [nil, self, other]
      end
    end)
  rescue
  end
end
Array.prepend(Module.new do
  def | other
    return self << other
  end
  def [] key
    if key.is_a? Array
      if ~key == 2
        return self[key[1]..key[2]].insert 0, nil
      elsif ~key > 2
        return self[key[1]..key[2]] * key[3]
      else
        super
      end
    elsif self == u8
      return Array.new key + 1
    elsif key.is_a? String
      return self[1..~self] * key
    else
      super
    end
  end
  def []= key, other
    if (key.is_a? Array) && ~key == 2
      for i in key[1]..key[2]
        self[i] = other
      end
    elsif key == 0
      self[1 | ~self] = other
    else
      super
    end
  end
  def ~
    return self.length - 1
  end
end)
def u8
  return []
end
def say_single a
  if a.is_a? Array
    puts a[" | "]
  else
    puts a
  end
end
def say *a
  a.each{|i| say_single i}
end
def cyber a
  if a.is_a? Integer
    return a.chr Encoding::UTF_8
  elsif a.is_a? Array
    return a.map{|i| i && (cyber i)}.join
  end
end
def says a
  say cyber a
end
