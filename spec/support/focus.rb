RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.filter_run_excluding skip: true
  config.run_all_when_everything_filtered = true

  helpers = Module.new do
    def focus *args, &block
      it *(args << :focus), &block
    end

    def skip *args, &block
      it *(args << :skip), &block
    end
  end
  config.include helpers
end
