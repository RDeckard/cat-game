require "lib/rddr-libs/require.rb"

require "app/require.rb"

def tick(args)
  @tick ||= RDDR::Tick.new(TitleScreen)

  @tick.call
end
