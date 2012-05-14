# encoding: UTF-8
require 'spec_helper'

describe SheetsController do
  it_should_behave_like "inherit_resources with",
    'sheet',
    %w{new show index edit destroy}
end
