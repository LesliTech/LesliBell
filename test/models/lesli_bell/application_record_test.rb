require "test_helper"

module LesliBell
    class ApplicationRecordTest < ActiveSupport::TestCase
        test "is an abstract Lesli application record" do
            assert_predicate ApplicationRecord, :abstract_class?
            assert_operator ApplicationRecord, :<, Lesli::ApplicationLesliRecord
        end
    end
end
