class TitleScreen < GTKObject
  def initialize
    @text_box = TextBox.new(text_lines, text_alignment: :center)
  end

  def tick
    render

    next_scene if inputs.keyboard.key_down.enter
  end

  def render
    return if @render

    outputs.static_primitives.clear

    outputs.static_primitives << {
      path: "assets/images/mouse.png"
    }.sprite!(geometry.center_inside_rect({w: 128, h: 128}, grid))

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
        text: "ENTER: Start",
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

    state.current_scene = CatGame.new
  end
end
