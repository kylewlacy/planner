class Session < Token
  validates_presence_of :client_value
end
