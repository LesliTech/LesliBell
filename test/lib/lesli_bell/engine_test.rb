require "test_helper"

module LesliBell
    class EngineTest < ActiveSupport::TestCase
        test "is an isolated Rails engine" do
            assert_operator Engine, :<, Rails::Engine
            assert_predicate Engine, :isolated?
        end

        test "exposes its migration path" do
            migration_path = Engine.root.join("db", "migrate").to_s

            assert_includes Engine.config.paths["db/migrate"].expanded, migration_path
        end
    end
end
