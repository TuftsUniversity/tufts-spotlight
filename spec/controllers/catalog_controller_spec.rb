require 'rails_helper'
require 'lib/fedora_helpers/config_parser_spec'

describe CatalogController do
  it_behaves_like FedoraHelpers::ConfigParser
end
