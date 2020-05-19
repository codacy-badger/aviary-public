# models/concerns/xml_file_handler.rb
# Module XMLFileHandler
# XML File Handler
module XMLFileHandler
  extend ActiveSupport::Concern

  def xml_validation(doc, check_type = '')
    xsds = Dir.glob("#{Rails.root}/public/ohms xsd/*.xsd")
    error_found = 0
    error_messages = []
    xsds.each do |schema|
      xsd = Nokogiri::XML::Schema(File.read(schema.to_s))
      validation = xsd.validate(doc)
      if validation.any? && validation.include?(check_type)
        error_found += 1
        error_messages = validation
      end
    end
    if error_found == xsds.length
      return error_messages
    end
    []
  end
end
