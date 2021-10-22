class TitleScreen < RDDR::GTKObject
  FLOOR_IMAGE  = "assets/images/floor.png".freeze

  MOUSE_IMAGE  = "assets/images/mouse.png".freeze
  MOUSE_WIDTH  = 599
  MOUSE_HEIGHT = 504
  MOUSE_SCALE_MIN   = 0.1
  MOUSE_SCALE_MAX   = 0.5
  DEFAULT_MOUSE_SCALE = 0.3

  def initialize
    @floor = { path: FLOOR_IMAGE }.merge(grid.rect.to_hash).sprite!

    @text_box = RDDR::TextBox.new(text_lines, frame_alignment_v: grid.top.shift_down(grid.h/3), text_alignment: :center)

    @slider = RDDR::Slider.new(x: 0, y: grid.bottom.shift_up(grid.h/6), w: grid.w/3, h: 40,
                         min_value: MOUSE_SCALE_MIN, max_value: MOUSE_SCALE_MAX,
                         text: "Mouse size", text_size: 4)
    @slider.x = geometry.center_inside_rect_x(@slider.bar, grid.rect).x

    @mouse_space = { x: grid.left, y: @slider.slide.top, w: grid.right, h: @text_box.frame.bottom - @slider.slide.top }
    @mouse = {
      path: MOUSE_IMAGE,
      w: MOUSE_WIDTH*DEFAULT_MOUSE_SCALE, h: MOUSE_HEIGHT*DEFAULT_MOUSE_SCALE
    }.sprite!
    @mouse.merge!(geometry.center_inside_rect(@mouse, @mouse_space))
  end

  def tick
    render

    handler_inputs

    next_scene if inputs.keyboard.key_down.enter
  end

  def handler_inputs
    @slider.handler_inputs do |mouse_scale|
      @mouse.w = MOUSE_WIDTH*mouse_scale
      @mouse.h = MOUSE_HEIGHT*mouse_scale
      @mouse.merge!(geometry.center_inside_rect(@mouse, @mouse_space))
    end
  end

  def render
    return if @render

    outputs.static_primitives.clear

    outputs.static_primitives << [@floor, @text_box.primitives, @slider.primitives, @mouse]

    # Legendes
    outputs.static_primitives << [
      {
        x: grid.left.shift_right(5), y: grid.bottom.shift_up(65),
        text: "By RDeckard",
        r: 128, g: 128, b: 128
      }.label!,
      {
        x: grid.left.shift_right(5), y: grid.bottom.shift_up(45),
        text: "GitHub: https://github.com/RDeckard/cat-game/",
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
    state.current_scene = CatGame.new(@floor, @mouse)
  end
end
