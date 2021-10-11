require "lib/serializable.rb"
require "lib/spriteable.rb"
require "lib/gtk_object.rb"
require "lib/tools/prompt.rb"
require "lib/tools/menu.rb"
require "lib/tools/text_box.rb"
require "app/scenes/title_screen.rb"

def tick(args)
  args.state.current_scene ||= TitleScreen.new

  args.state.current_scene.tick

  handle_quit_and_reset
rescue => e
  # HOTFIX DragonRuby: raise exception correctly when using blocks/procs/lambdas
  puts "+-" * 50
  puts e
  puts e.backtrace.join("\n")
  puts "+-" * 50
  raise e
end

def handle_quit_and_reset
  if $gtk.args.inputs.keyboard.key_held.alt && $gtk.args.inputs.keyboard.key_down.f
    $gtk.args.state.window_fullscreen = !$gtk.args.state.window_fullscreen
    $gtk.set_window_fullscreen($gtk.args.state.window_fullscreen)
  end

  if $gtk.args.inputs.keyboard.key_held.alt && $gtk.args.inputs.keyboard.key_down.q
    $gtk.request_quit unless $gtk.platform?(:html)
    $gtk.reset
  end

  $gtk.reset if $gtk.args.inputs.keyboard.key_held.alt && $gtk.args.inputs.keyboard.key_down.r
end
