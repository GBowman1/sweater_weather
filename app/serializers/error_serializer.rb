class ErrorSerializer
  include FastJsonapi::ObjectSerializer
  
  attribute :error do |error|
    error.message
    error.status
  end
end