class Uuid 
  
  def self.get()
  	uuid = UUIDTools::UUID.timestamp_create.to_s.gsub('-','')
  	return uuid
  end
end
