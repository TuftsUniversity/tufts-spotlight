# @file
# Contains helper methods mainly used in ConfigParserDisplay feature spec

module FedoraFieldMacros

  ##
  # Gets the field names from fields in fedora_fields.yml.
  #
  # @param {array} fields
  #   Fields to get the names out of.
  #
  # @return {array}
  #   Collected names of the fields.
  def get_field_names(fields)
    field_names = []

    fields.each do |f|
      if(f[:name].nil?)
        new_name = f[:field].capitalize
      else
        new_name = f[:name]
      end

      if(block_given?)
        new_name = yield new_name
      end

      field_names << new_name
    end

    field_names
  end

  ##
  # Gets the texts from a set of elements.
  #
  # @param {string} selector
  #   The css selector to search for.
  #
  # @return {array}
  #   All the texts from the elements.
  def get_element_texts(selector)
    texts = []

    all(selector).each do |el|
      if(el.text)
        texts << el.text
      end
    end

    texts
  end
end

