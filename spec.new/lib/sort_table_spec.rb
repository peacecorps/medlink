require "rails_helper"

describe SortTable do
  Given(:scope) { Country.where("") }

  context "building prevents duplicates" do
    Given!(:old)  { SortTable.build scope, prefix: "thing", params: {} }
    When(:result) { SortTable.build scope, prefix: "thing", params: {} }

    Then { result == Failure(SortTable::Duplicate, /thing/) }
  end

  context "have to use build" do
    When(:result) { SortTable.new }

    Then { result == Failure(NoMethodError, /protected/) }
  end

  context "paginates" do
    When(:result) { SortTable.build scope, params: {}, per_page: 10 }

    Then { result.count == 10      }
    And  { result.total_pages == 7 }
  end

  skip "need view specs"
  #context "builds links" do
  #  Given(:table) { SortTable.build scope, prefix: "links", params: {} }

  #  When(:result) { table.header :name, title: "Country Name" }
  #end
end
