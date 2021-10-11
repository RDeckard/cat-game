class TitleScreen < GTKObject
  def initialize
    @text_box = TextBox.new(text_lines, text_alignment: :center)
  end

  def tick
    render

    next_scene if inputs.keyboard.key_down.enter || inputs.mouse.click
  end

  def render
    return if @render

    outputs.static_primitives.clear

    box = @text_box.primitives.first.dup

    scale = box.h/504
    sprite_width = 599*scale

    outputs.static_primitives << box.sprite!(
      { x: box.x + (box.w - sprite_width)/2, w: sprite_width, path: "assets/images/mouse.png" }
    )

    outputs.static_primitives << @text_box.primitives

    outputs.static_primitives << [
      {
        x: grid.left.shift_right(5), y: grid.bottom.shift_up(65),
        text: "By RDeckard",
        r: 128, g: 128, b: 128
      }.label!,
      {
        x: grid.left.shift_right(5), y: grid.bottom.shift_up(45),
        text: "GitHub: https://github.com/RDeckard/cat_game/",
        r: 128, g: 128, b: 128
      }.label!,
      {
        x: grid.left.shift_right(5), y: grid.bottom.shift_up(25),
        text: "itch.io: https://rdeckard.itch.io/cat-game",
        r: 128, g: 128, b: 128
      }.label!,
      {
        x: grid.right.shift_left(5), y: grid.bottom.shift_up(25),
        text: "Click/ENTER: Start",
        size_enum: 2,
        alignment_enum: 2
      }.label!
    ]

    @render = true
  end

  def text_lines
    [
      "CAT GAME",
      "",
      "--- Shortcuts ---",
      "Toggle fullscreen: Alt+F",
      "Reset: Alt+R",
      "Quit: Alt+Q",
    ]
  end

  def next_scene
    outputs.static_primitives.clear
    gtk.hide_cursor

    state.current_scene = CatGame.new
  end
end
